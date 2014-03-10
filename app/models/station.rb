class Station < ActiveRecord::Base
  validates_presence_of :hostname, :password, :location
  validates_inclusion_of :enabled, in: [ true, false ]

  has_many :user_locations

  before_destroy :do_not_delete_local_station

  def self.local_station
    self.where(local: true).first!
  end

  def communicated!(remote_ip=nil)
    update_attributes(
      last_seen_at: Time.now,
      last_ip_address: remote_ip
    )
  end

private

  def do_not_delete_local_station
    if local?
      errors[:base] << "cannot delete the local station"
      return false
    end
  end
end
