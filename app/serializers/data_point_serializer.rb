class DataPointSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper
  attributes :id, :station_id, :name, :data, :created_at, :created_at_relative

  def created_at_relative
    time_ago_in_words(created_at)
  end
end
