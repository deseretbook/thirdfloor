class UserLocation < ActiveRecord::Base
  belongs_to :user
  belongs_to :station

  default_scope -> { order('id') }

  def here?
    true
  end
end
