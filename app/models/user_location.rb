class UserLocation < ActiveRecord::Base
  belongs_to :user
  belongs_to :station

  default_scope -> { order('id DESC') }

  after_save :delete_old_records

  # true if created_at is after 7am
  def in_office_today?
    @in_office_today ||= created_at > Time.parse('7am')
  end

private

  # doing this here saves managing a cron job
  def delete_old_records
    # only do this ~20% of the time
    if rand(10) >= 8
      UserLocation.where(['created_at < ?', 2.days.ago]).delete_all
    end
  end

end
