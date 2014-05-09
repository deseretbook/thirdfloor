class AddAutoscrollControlToCells < ActiveRecord::Migration
  def change
    add_column :dashboard_cells, :autoscroll, :boolean, default: true, null: false
    add_column :dashboard_cells, :autoscroll_delay, :integer
  end
end
