class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :hostname, null: false
      t.string :password, null: false
      t.string :location, null: false
      t.boolean :enabled, default: false, null: false
      t.datetime :last_seen_at
      t.string :last_ip_address
      t.timestamps
    end

    add_index :stations, :hostname, unique: true
  end
end
