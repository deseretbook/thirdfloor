class CreateDataPoints < ActiveRecord::Migration
  def change
    create_table :data_points do |t|
      t.integer :station_id, null: false
      t.string :name, null: false
      t.hstore :data
      t.timestamps
    end

    add_index :data_points, :name
  end
end
