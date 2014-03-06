class User < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :bluetooth_address
  validates_uniqueness_of :first_name, scope: :last_name
  validates_uniqueness_of :bluetooth_address, allow_blank: true
  validates_inclusion_of :track_location, in: [ true, false ]

  has_many :user_locations
end
