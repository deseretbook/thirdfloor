class AddMaximumHeightToDashboardCell < ActiveRecord::Migration
  def change
    add_column :dashboard_cells, :maximum_height, :string
  end
end
