class Visualization < ActiveRecord::Base
  validates_presence_of :name, :slug
  validates_inclusion_of :markup_type, in: %i[ html erb slim ]
  validates_format_of :slug, with: /[a-z0-9_\-]+/

  has_many :dashboard_cells, dependent: :destroy

  before_validation :populate_slug

  def markup_type
    read_attribute(:markup_type).to_sym
  end

private

  def populate_slug
    if self.slug.blank? && self.name.present?
      self.slug = self.name.downcase.gsub(/([^a-z0-9_\-_]+)/, '_')
    end
  end
end
