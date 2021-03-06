class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :bluetooth_address
      t.boolean :track_location, default: false, null: false
      t.string :avatar_url
      t.timestamps
    end

    add_index :users, [ :first_name, :last_name], unique: true
    add_index :users, :bluetooth_address, unique: true
  end
end
