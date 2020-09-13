class AddFitnessLevelColumnToTactics < ActiveRecord::Migration[6.0]
  def change
    add_column :tactics, :fitness_level, :integer
  end
end
