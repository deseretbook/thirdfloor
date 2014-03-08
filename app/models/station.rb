class Station < ActiveRecord::Base
  validates_presence_of :hostname, :password, :location
  validates_inclusion_of :enabled, in: [ true, false ]

  has_many :user_locations

  def communicated!(remote_ip=nil)
    update_attributes(
      last_seen_at: Time.now,
      last_ip_address: remote_ip
    )
  end
end
