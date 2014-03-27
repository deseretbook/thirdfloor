class CreateDashboardCells < ActiveRecord::Migration
  def change
    create_table :dashboard_cells do |t|
      t.integer :dashboard_id, null: false
      t.integer :visualization_id, null: false
      t.integer :columns, null: true
      t.integer :position, default: 0, null: false

      t.timestamps
    end

    add_index :dashboard_cells, :dashboard_id
    add_index :dashboard_cells, :visualization_id
  end
end
