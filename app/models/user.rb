require "tty-prompt"
require "colorize"
require "tty-box"

class User < ActiveRecord::Base
    has_many :user_tactics
    has_many :tactics, through: :user_tactics

    def suggested_activities
        Tactic.all.filter { |tactic| tactic.goal == self.goal && (tactic.fitness_level == self.fitness_level || tactic.fitness_level == nil) }
    end 

    def self.sign_up
        prompt = TTY::Prompt.new
        username = prompt.ask("Please enter a username.".colorize(:cyan))
        if User.all.find_by(username: username)
            puts "This username already exists. Please select another one."
            return self.sign_up
        end
        password = prompt.mask("Please create a password.".colorize(:cyan))
        name = prompt.ask("Please enter your name.".colorize(:cyan))
        options = ["Lose Weight", "Build Muscle"]
        goal = prompt.select("Please select a fitness goal.".colorize(:cyan), options) 
        height = prompt.ask("Please enter your height in inches.".colorize(:cyan))
        weight = prompt.ask("Please enter your weight in pounds.".colorize(:cyan))
        fitness_level = prompt.select("How would you describe your fitness level.") do |menu|
            menu.choice name: "Sedentary".colorize(:yellow), value: 1
            menu.choice name: "Moderate".colorize(:cyan), value: 2
            menu.choice name: "Active".colorize(:red), value: 3
        end
        User.create(username: username, password: password, name: name, goal: goal, height: height, weight: weight, fitness_level: fitness_level)
    end 

    def add_user_tactics
        self.suggested_activities.each { |activity| UserTactic.create(user: self, tactic: activity) }
    end

    def self.login
        prompt = TTY::Prompt.new
        username = prompt.ask("Please enter your username.".colorize(:cyan))
        password = prompt.mask("Please enter your password.".colorize(:cyan))
        user = User.all.find_by(username: username, password: password)
        if !user 
            puts "Your username and/or password is incorrect. Please re-enter."
            return self.login
        else
            user
        end
    end

    def view_activities
        activities = self.tactics.map { |tactic| tactic.action }
        print TTY::Box.frame { activities }
    end

    def completed_activities
        activities = self.user_tactics.filter { |ut| ut.completed == true }.map { |ut| ut.tactic.action.colorize(:cyan) }
        if activities.length == 0
            print TTY::Box.frame { "You haven't completed any activities...yet :)" }
        else
            activities
        end
    end 

    def incomplete_activities 
        self.user_tactics.filter { |ut| ut.completed == false }.map { |ut| ut.tactic.action }
    end 

    def select_activity
        prompt = TTY::Prompt.new
        choices = self.incomplete_activities
        if choices.length == 0
            box = TTY::Box.frame(border: :thick, title: {top_left: "CONGRATS"}) {"\nYou have completed all activities for your goal of: #{self.goal}!"}
            print box
            return
        end
        selection = prompt.select("Select an activity to view or complete'", choices)
        tactic = self.tactics.find_by(action: selection)
        print TTY::Box.frame { tactic.description.colorize(:cyan) }
        completed = prompt.select("Did you complete this activity?", ["Yes", "No"])
        if completed == "Yes"
            change_status(tactic)
        end
    end

    def change_status(tactic)
        ut = UserTactic.find_by(tactic: tactic, user: self)
        ut.update(completed: true)
        Gif.go
        # need to invoke gif.rb here to make it happen
    end 

    def other_users
        completed_tactics = UserTactic.all.filter { |ut| ut.completed == true }
        others = completed_tactics.filter { |ut| ut.user != self }
        others.map { |ut| "#{ut.user.name} completed a task - #{ut.tactic.action}".colorize(:cyan) }
    end

    def view_profile
        prompt = TTY::Prompt.new
        fitness_levels = {1 => "Sedentary", 2 => "Moderate", 3 => "Active"}
        print TTY::Box.frame "Height: #{self.height} inches\nWeight: #{self.weight} pounds\nCurrent fitness goal: #{self.goal}\nCurrent fitness level: #{fitness_levels[self.fitness_level]}\n#{self.count_activities}"
        choice = prompt.select("Select an option") do |menu|
            menu.choice name: "Edit profile".colorize(:cyan), value: 1
            menu.choice name: "Go back".colorize(:cyan), value: 2
        end
        if choice == 1
            self.edit_profile
        end
    end

    def edit_profile
        prompt = TTY::Prompt.new
        choice = prompt.select("Select an item to update.") do |menu|
            menu.choice name: "Height".colorize(:yellow), value: 1
            menu.choice name: "Weight".colorize(:cyan), value: 2
            menu.choice name: "Fitness goal".colorize(:red), value: 3
            menu.choice name: "Fitness level".colorize(:blue), value: 4
        end
        if choice == 1
            self.change_height
        elsif choice == 2
            self.change_weight
        elsif choice == 3
            self.change_goal
        elsif choice == 4
            self.change_fitness_level
        end
    end

    def count_activities
        points = self.user_tactics.filter { |ut| ut.completed == true }.map { |ut| ut.tactic.action }.count
        "Health points: #{points.to_s.colorize(:red)} (for #{points} completed activities!)"
    end

    def change_height
        prompt = TTY::Prompt.new
        options = ["Yes", "No"]
        update = prompt.select("Would you like to update your height?", options)
        if update == "Yes"
            new_height = prompt.ask("Please enter your updated height in inches:")
            self.update(height: new_height)
        end
    end

    def change_weight
        prompt = TTY::Prompt.new
        options = ["Yes", "No"]
        update = prompt.select("Would you like to update your weight?", options)
        if update == "Yes"
            new_weight = prompt.ask("Please enter your updated weight in pounds:")
            self.update(weight: new_weight)
        end
    end

    def change_fitness_level
        prompt = TTY::Prompt.new
        options = ["Yes", "No"]
        update = prompt.select("Would you like to change your fitness level? \n*Caution: changing your fitness level will delete current progress and refresh with new activities", options)
        if update == "Yes"
            new_fitness_level = prompt.select("How would you describe your fitness level.") do |menu|
                menu.choice name: "Sedentary".colorize(:yellow), value: 1
                menu.choice name: "Moderate".colorize(:cyan), value: 2
                menu.choice name: "Active".colorize(:red), value: 3
            end
            self.user_tactics.each { |ut| ut.destroy }
            self.update(fitness_level: new_fitness_level)
            self.add_user_tactics
        end
    end
   
    def change_goal
        prompt = TTY::Prompt.new
        options = ["Yes", "No"]
        update = prompt.select("Would you like to change your goal?\n*Caution: changing your goal will delete current progress and refresh with new activities", options)
        if update == "Yes"
            self.user_tactics.each { |ut| ut.destroy }
            options = ["Lose Weight", "Build Muscle"]
            goal = prompt.select("Please select a fitness goal.", options) 
            self.update(goal: goal)
            self.add_user_tactics
        end
    end 

end 
