class User < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :bluetooth_address
  validates_uniqueness_of :first_name, scope: :last_name
  validates_uniqueness_of :bluetooth_address, allow_blank: true, allow_nil: true
  validates_inclusion_of :track_location, in: [ true, false ]

  has_many :user_locations

  def name
    [first_name, last_name].join(' ')
  end

  def self.find_by_name(full_name_str)
    f,l = full_name_str.split(' ')
    self.where(first_name: f, last_name: l).first
  end
end
