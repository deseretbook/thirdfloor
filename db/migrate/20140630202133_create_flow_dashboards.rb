class CreateFlowDashboards < ActiveRecord::Migration
  def change
    create_table :flow_dashboards do |t|
      t.integer :flow_id, null: false
      t.integer :dashboard_id, null: false
      t.integer :refresh, null: false, default: 0
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :flow_dashboards, [ :flow_id ]
    add_index :flow_dashboards, [ :dashboard_id ]
    add_index :flow_dashboards, [ :flow_id, :dashboard_id ], unique: true
  end
end
