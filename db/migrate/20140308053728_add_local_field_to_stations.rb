class AddLocalFieldToStations < ActiveRecord::Migration
  def change
    add_column :stations, :local, :boolean, default: false

    add_index :stations, :local
  end
end
