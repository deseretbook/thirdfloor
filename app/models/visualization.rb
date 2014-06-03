class Visualization < ActiveRecord::Base
  validates_presence_of :name, :slug, case_sensitive: false
  validates_inclusion_of :markup_type, in: %i[ html erb slim ]
  validates_format_of :slug, with: /[a-z0-9_\-]+/
  validates_length_of :data_point_name, allow_blank: true, maximum: 255.bytes

  has_many :dashboard_cells, dependent: :destroy

  after_save :touch_connected_cells

  before_validation :populate_slug

  scope :enabled, -> { where(enabled: true) }
  scope :disabled, -> { where(enabled: false) }

  def markup_type
    read_attribute(:markup_type).to_sym
  end

  def disabled?
    !enabled?
  end

  # Return visualization#markup, but replace strings with data structures.
  # __READY_EVENT__   : name of the JS event signaling the page is ready.
  # __REFRESH_EVENT__ : name of the JS event signaling the vis should refresh.
  # __DIV_ID__        : DOM ID of the div containing the visualizartion.
  def interpolated_markup
    visualization.markup.tap do |markup|
      [
        [ :ready_event, 'tf_ready' ],
        [ :refresh_event, "tf_refresh_#{visualization.slug}" ],
        [ :div_id, div_id ]
      ].each do |k, v|
        markup.gsub!("__#{k.upcase}__", v.to_s)
      end
    end
  end

  def div_id
    "visualization_#{id}"
  end

  def ready_event_name
    'tf_ready'
  end

  def refresh_event_name
    "tf_refresh_#{slug}"
  end

  def interpolation_values
    {}.tap do |h|
      [
        [ :ready_event, ready_event_name ],
        [ :refresh_event, refresh_event_name ],
        [ :div_id, div_id ]
      ].each do |k, v|
        h[k] = v
      end
    end
  end

  # Return visualization#markup, but replace strings with data structures.
  # __READY_EVENT__   : name of the JS event signaling the page is ready.
  # __REFRESH_EVENT__ : name of the JS event signaling the vis should refresh.
  # __DIV_ID__        : DOM ID of the div containing the visualizartion.
  def interpolated_markup
    markup.tap do |markup|
      interpolation_values.each do |k,v|
        markup.gsub!("__#{k.upcase}__", v.to_s)
      end
    end
  end

private

  def populate_slug
    if self.slug.blank? && self.name.present?
      self.slug = self.name.downcase.gsub(/([^a-z0-9_\-_]+)/, '_')
    end
  end

  # We want to reset the updated_at on any dashboard_cells that use this
  # one when anything changes so any associated dashboards can also change.
  # The "touch: true" method doesn't work with has_many, so we do this instead.
  def touch_connected_cells
    dashboard_cells.each(&:touch)
  end
end
