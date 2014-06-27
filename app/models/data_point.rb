class DataPoint < ActiveRecord::Base
  MAXIMUM_RECORD_AGE = { number: 10, unit: :days }

  serialize :data, ActiveRecord::Coders::NestedHstore

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

  def self.maximum_record_age(format=:date)
    case format
    when :words
      "#{MAXIMUM_RECORD_AGE[:number]} #{MAXIMUM_RECORD_AGE[:unit]}"
    else # :date
      MAXIMUM_RECORD_AGE[:number].send(MAXIMUM_RECORD_AGE[:unit]).ago
    end
  end

  private

  # doing this here saves managing a cron job
  def delete_old_records
    # only do this ~20% of the time
    if rand(10) >= 8
      DataPoint.where(
        ['created_at < ?', self.class.maximum_record_age]
      ).delete_all
    end
  end

  def flush_newest_for_cache
    Rails.cache.delete(self.class.newest_cache_key(name))
  end

end
