require "tty-prompt"
class CLI

    def start
        self.logo
        self.welcome
        self.menu
    end

    def logo
        puts"

        ██╗  ██╗ █████╗ ██████╗ ██╗████████╗    ██╗  ██╗███████╗██╗     ██████╗ ███████╗██████╗ 
        ██║  ██║██╔══██╗██╔══██╗██║╚══██╔══╝    ██║  ██║██╔════╝██║     ██╔══██╗██╔════╝██╔══██╗
        ███████║███████║██████╔╝██║   ██║       ███████║█████╗  ██║     ██████╔╝█████╗  ██████╔╝
        ██╔══██║██╔══██║██╔══██╗██║   ██║       ██╔══██║██╔══╝  ██║     ██╔═══╝ ██╔══╝  ██╔══██╗
        ██║  ██║██║  ██║██████╔╝██║   ██║       ██║  ██║███████╗███████╗██║     ███████╗██║  ██║
        ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝   ╚═╝       ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝        
       "
          .colorize(:color => :magenta)
          sleep(1)
    end

    def welcome
        puts " Welcome to the Habit Helper! This application is designed to help you form strong habits to improve your overall health and wellness. \n"
        .colorize(:color => :light_cyan)
        sleep(2)
        puts "\n We would also like to congratulate you on living in the greatest city in the world - New York! \n"
        .colorize(:color => :light_cyan)
        sleep(3)
        puts "\n Understandably, living in a big city makes you aware of personal fitness; being winded from walking a couple of blocks to catch the 7 is not fun. \n"
        .colorize(:color => :light_cyan)
        sleep(5)
        puts "\n Use the Habit Helper to catch up to your peers and stun them the next time you're at a secret party in SoHo, on a beach in the Hamptons, or sunbathing in Central Park. \n"
        .colorize(:color => :light_cyan)
        sleep(5)
        puts "\n Remember to have fun and be patient with yourself. It takes 21 days on average to form a new habit. With the Habit Helper, this will soon become second nature. \n"
        .colorize(:color => :light_cyan)
        sleep(3)
        prompt = TTY::Prompt.new
        choices = ["Log in", "Sign up"]
        selection = prompt.select("Select an option:", choices)
        if selection == "Log in"
            @user = User.login
        elsif selection == "Sign up"
            @user = User.sign_up
            @user.add_user_tactics
            @user.reload
        end
    end

    def menu
        choices = {"View profile" => 1, "View my activity log" => 2, "View available activities" => 3, "View feed" => 4, "View Strava" => 5, "Logout" => 6}
        prompt = TTY::Prompt.new
        selection = prompt.select("Menu options:", choices)
        if selection == 1
            puts @user.view_profile
            @user.reload
        elsif selection == 2
            puts @user.completed_activities
        elsif selection == 3
            @user.select_activity
            @user.reload
        elsif selection == 4
            puts @user.other_users
        elsif selection == 5
            strava = Strava.new
            strava.direct_user
            strava.display_activities
        elsif selection == 6
            abort "Stay healthy! 🍏".colorize(:red)
        end
        #prompt.select("Return to main menu")
        menu
    end


end