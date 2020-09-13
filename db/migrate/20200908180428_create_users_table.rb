class CreateUsersTable < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :name
      t.string :goal
      t.float :height
      t.float :weight
      t.integer :fitness_level
    end
  end
end