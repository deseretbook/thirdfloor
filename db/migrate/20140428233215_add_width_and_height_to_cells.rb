class AddWidthAndHeightToCells < ActiveRecord::Migration
  def change
    add_column :dashboard_cells, :width, :integer, default: 1, null: false
    add_column :dashboard_cells, :height, :integer, default: 1, null: false
    add_column :dashboard_cells, :column, :integer, default: 1, null: false
    add_column :dashboard_cells, :row, :integer, default: 1, null: false

    remove_column :dashboard_cells, :maximum_height, :string
    remove_column :dashboard_cells, :columns, :integer, null: true
  end
end
