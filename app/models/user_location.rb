class UserLocation < ActiveRecord::Base
  belongs_to :user
  belongs_to :station

  default_scope -> { order('id') }
end
