# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

station = Station.create!(
  hostname: "raspbian",
  password: "SECRET!",
  location: "Third Floor, West",
  enabled: true
)

# local station representing the site itself. There can be only one.
Station.create!(
  hostname: "localhost",
  password: "SECRET!",
  location: "Inside the app",
  local: true,
  enabled: true
)

[
  [ "Matthew", "Nielsen", "F8:27:93:31:A8:A9", "https://trello-avatars.s3.amazonaws.com/bc632f608d5d884f7c32d65aefad549b/30.png" ],
  [ "Matt", "Redd", "B8:E8:56:F0:AB:16", "https://trello-avatars.s3.amazonaws.com/9b3598d5177ac5515df7815605d49186/30.png" ],
  [ "Mike", "Bourgeous", nil, "https://trello-avatars.s3.amazonaws.com/eb1017b7332755909f514f040c2214b7/30.png" ],
  [ "Tory", "Briggs", nil, "https://trello-avatars.s3.amazonaws.com/eb1017b7332755909f514f040c2214b7/30.png" ],
  [ "Tim", "Hogg", nil, "https://trello-avatars.s3.amazonaws.com/eb1017b7332755909f514f040c2214b7/30.png" ],
  [ "Tom", "Welch", "64:A3:CB:35:D6:89", "https://trello-avatars.s3.amazonaws.com/9bd2fae77a8db00d984ec9a96900bd01/30.png" ],
  [ "Ben", "Lopshire", "3C:D0:F8:01:73:6B", "https://trello-avatars.s3.amazonaws.com/f672bb5a40ddf426d32f2d0a7d0fd28f/30.png" ],
  [ "Logan", "Mallory", nil, "https://trello-avatars.s3.amazonaws.com/254f69a74adbf945974db913dd196153/30.png" ],
  [ "Rob", "Johnson", "18:AF:61:4F:84:00", "https://trello-avatars.s3.amazonaws.com/743a5aea47083e84b93d84bc3a6aaf95/30.png" ],
  [ "Joseph", "McLaughlin", nil, "https://trello-avatars.s3.amazonaws.com/b846760769c60325796b651af31be6d8/30.png" ],
  [ "Greg", "Price", "54:26:96:43:AC:31", "https://trello-avatars.s3.amazonaws.com/5c5babb048f683ef27cbf61a305e2bb1/30.png" ],
].each do |fn, ln, bt, au|
  puts "Creating #{fn} #{ln}"
  user = User.create!(
    first_name: fn,
    last_name: ln,
    bluetooth_address: bt || (0...32).map{65.+(rand(25)).chr}.join,
    avatar_url: au,
    track_location: true
  )

  ul = UserLocation.create!(
    user_id: user.id,
    station_id: station.id
  )
  ul.update_column(:created_at, 1.day.ago)
end

vis_markup = <<MARKUP
<script>
  $(document).ready(function(){
    $.get('/data_points.json?name=daily_sales&limit=1').done(function(returned_data) {
      $('#sales_today').html(returned_data.data_points[0].data.sales);
      $('#orders_today').html(returned_data.data_points[0].data.orders);
    });
  });
</script>
<div>
  <div class='sales'>Sales today: <span id='sales_today'>Loading...</span></div>
  <div class='orders'>Orders today: <span id='orders_today'>Loading...</span></div>
</div>
MARKUP

Visualization.create!(
  name: 'Totals Today',
  markup_type: 'html',
  markup: vis_markup
)
 