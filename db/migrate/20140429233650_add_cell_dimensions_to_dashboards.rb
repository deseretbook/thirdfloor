class AddCellDimensionsToDashboards < ActiveRecord::Migration
  def change
    add_column :dashboards, :cell_width, :integer, default: 100, null: false
    add_column :dashboards, :cell_height, :integer, default: 100, null: false
    add_column :dashboards, :cell_x_margin, :integer, default: 5, null: false
    add_column :dashboards, :cell_y_margin, :integer, default: 5, null: false
    add_column :dashboards, :refresh_to, :integer, null: true

    remove_column :dashboards, :columns, :integer, null: false, default: 1
  end
end
