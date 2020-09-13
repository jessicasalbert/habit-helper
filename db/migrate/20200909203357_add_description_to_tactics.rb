class AddDescriptionToTactics < ActiveRecord::Migration[6.0]
  def change
    add_column :tactics, :description, :text
  end
end
