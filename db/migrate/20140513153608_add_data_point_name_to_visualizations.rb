class AddDataPointNameToVisualizations < ActiveRecord::Migration
  def change
    add_column :visualizations, :data_point_name, :text
  end
end
