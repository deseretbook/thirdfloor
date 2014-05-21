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
