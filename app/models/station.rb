class Station < ActiveRecord::Base
  validates_presence_of :hostname, :password, :location
  validates_inclusion_of :enabled, in: [ true, false ]

  has_many :user_locations

  def communicated!
    update_attributes(last_responded_at: Time.now)
  end
end
