class DataPoint < ActiveRecord::Base
  belongs_to :station
  default_scope -> { order('id DESC') }

  after_save :delete_old_records

  def self.newest_for(name)
    where(name: name).first
  end

  private

  # doing this here saves managing a cron job
  def delete_old_records
    # only do this ~20% of the time
    if rand(10) >= 8
      DataPoint.where(['created_at < ?', 14.days.ago]).delete_all
    end
  end

end
