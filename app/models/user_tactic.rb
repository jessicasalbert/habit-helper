class UserTactic < ActiveRecord::Base
    belongs_to :user 
    belongs_to :tactic
end 