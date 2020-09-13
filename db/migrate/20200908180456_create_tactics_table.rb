class CreateTacticsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :tactics do |t|
     t.string :action
     t.string :goal 
    end
  end
end
