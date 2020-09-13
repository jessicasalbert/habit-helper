class CreateUserTacticsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :user_tactics do |t|
      t.integer :user_id
      t.integer :tactic_id
      t.boolean :completed, default: false
    end
  end
end
