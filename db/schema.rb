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

ActiveRecord::Schema.define(version: 20140509222420) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "dashboard_cells", force: true do |t|
    t.integer  "dashboard_id",                    null: false
    t.integer  "visualization_id",                null: false
    t.integer  "position",         default: 0,    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "width",            default: 1,    null: false
    t.integer  "height",           default: 1,    null: false
    t.integer  "column",           default: 1,    null: false
    t.integer  "row",              default: 1,    null: false
    t.boolean  "autoscroll",       default: true, null: false
    t.integer  "autoscroll_delay"
  end

  add_index "dashboard_cells", ["dashboard_id"], name: "index_dashboard_cells_on_dashboard_id", using: :btree
  add_index "dashboard_cells", ["visualization_id"], name: "index_dashboard_cells_on_visualization_id", using: :btree

  create_table "dashboards", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.boolean  "enabled",          default: true
    t.integer  "refresh"
    t.text     "css"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cell_width",       default: 100,  null: false
    t.integer  "cell_height",      default: 100,  null: false
    t.integer  "cell_x_margin",    default: 5,    null: false
    t.integer  "cell_y_margin",    default: 5,    null: false
    t.integer  "refresh_to"
    t.integer  "maximum_width"
    t.integer  "maximum_height"
    t.boolean  "autoscroll",       default: true, null: false
    t.integer  "autoscroll_delay"
  end

  add_index "dashboards", ["slug"], name: "index_dashboards_on_slug", unique: true, using: :btree

  create_table "data_points", force: true do |t|
    t.integer  "station_id", null: false
    t.string   "name",       null: false
    t.hstore   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "data_points", ["name"], name: "index_data_points_on_name", using: :btree

  create_table "stations", force: true do |t|
    t.string   "hostname",                        null: false
    t.string   "password",                        null: false
    t.string   "location",                        null: false
    t.boolean  "enabled",         default: false, null: false
    t.datetime "last_seen_at"
    t.string   "last_ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "local",           default: false
  end

  add_index "stations", ["hostname"], name: "index_stations_on_hostname", unique: true, using: :btree
  add_index "stations", ["local"], name: "index_stations_on_local", using: :btree

  create_table "user_locations", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "station_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_locations", ["station_id"], name: "index_user_locations_on_station_id", using: :btree
  add_index "user_locations", ["user_id"], name: "index_user_locations_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name",                        null: false
    t.string   "last_name",                         null: false
    t.string   "bluetooth_address"
    t.boolean  "track_location",    default: false, null: false
    t.string   "avatar_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["bluetooth_address"], name: "index_users_on_bluetooth_address", unique: true, using: :btree
  add_index "users", ["first_name", "last_name"], name: "index_users_on_first_name_and_last_name", unique: true, using: :btree

  create_table "visualizations", force: true do |t|
    t.string   "name",                         null: false
    t.string   "slug",                         null: false
    t.string   "markup_type", default: "html", null: false
    t.text     "markup"
    t.boolean  "enabled",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "component",   default: false,  null: false
  end

end
