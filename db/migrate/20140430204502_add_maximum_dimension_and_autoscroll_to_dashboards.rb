class AddMaximumDimensionAndAutoscrollToDashboards < ActiveRecord::Migration
  def change
    add_column :dashboards, :maximum_width, :integer, null: true
    add_column :dashboards, :maximum_height, :integer, null: true
    add_column :dashboards, :autoscroll, :boolean, default: true, null: false
    add_column :dashboards, :autoscroll_delay, :integer, null: true
  end
end
