class CreateDashboards < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
      t.string :name
      t.string :slug
      t.boolean :enabled, default: true
      t.integer :refresh
      t.text :css
      t.integer :columns, null: false, default: 1

      t.timestamps
    end
    add_index :dashboards, :slug, unique: true
  end
end
