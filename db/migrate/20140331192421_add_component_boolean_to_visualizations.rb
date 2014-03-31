class AddComponentBooleanToVisualizations < ActiveRecord::Migration
  def change
    add_column :visualizations, :component, :boolean, default: false, null: false
  end
end
