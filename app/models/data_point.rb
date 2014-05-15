class DataPoint < ActiveRecord::Base
  belongs_to :station
  default_scope -> { order('id DESC') }

  after_save :delete_old_records

  after_commit :flush_newest_for_cache

  def self.newest_for(name, opts={})
    opts = { expires_in: 5.minutes }.merge(opts)
    Rails.cache.fetch(newest_cache_key(name), opts) do
      where(name: name).first
    end
  end

  def self.newest_cache_key(name)
    "newest_data_point_for_#{name}"
  end

  private

  # doing this here saves managing a cron job
  def delete_old_records
    # only do this ~20% of the time
    if rand(10) >= 8
      DataPoint.where(['created_at < ?', 14.days.ago]).delete_all
    end
  end

  def flush_newest_for_cache
    Rails.cache.delete(self.class.newest_cache_key(name))
  end

end
