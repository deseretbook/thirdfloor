# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(
  first_name: "Matthew",
  last_name: "Nielsen",
  bluetooth_address: "F8:27:93:31:A8:A9",
  track_location: true
)

Station.create!(
  hostname: "raspbian",
  password: "SECRET!",
  location: "Third Floor, West",
  enabled: true
)
