class Tactic < ActiveRecord::Base
    has_many :user_tactics
    has_many :users, through: :user_tactics
end 