# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140306160754) do

  create_table "stations", force: true do |t|
    t.string   "hostname",                          null: false
    t.string   "password",                          null: false
    t.string   "location",                          null: false
    t.boolean  "enabled",           default: false, null: false
    t.datetime "last_responded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stations", ["hostname"], name: "index_stations_on_hostname", unique: true

  create_table "user_locations", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "station_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_locations", ["station_id"], name: "index_user_locations_on_station_id"
  add_index "user_locations", ["user_id"], name: "index_user_locations_on_user_id"

  create_table "users", force: true do |t|
    t.string   "first_name",                        null: false
    t.string   "last_name",                         null: false
    t.string   "bluetooth_address"
    t.boolean  "track_location",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["bluetooth_address"], name: "index_users_on_bluetooth_address", unique: true
  add_index "users", ["first_name", "last_name"], name: "index_users_on_first_name_and_last_name", unique: true

end
