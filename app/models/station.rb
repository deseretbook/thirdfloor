class Station < ActiveRecord::Base
  validates_presence_of :hostname, :password, :location
  validates_inclusion_of :enabled, in: [ true, false ]

  has_many :user_locations
end
