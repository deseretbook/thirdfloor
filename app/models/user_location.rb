class UserLocation < ActiveRecord::Base
  belongs_to :user
  belongs_to :station

  default_scope -> { order('id') }

  # true if created_at is after 8am
  def in_office_today?
    @in_office_today ||= created_at > Time.parse('8am')
  end

end
