class Flow < ActiveRecord::Base
  validates_presence_of :name, :slug

  has_many :flow_dashboards, dependent: :destroy
  has_many :dashboards, through: :flow_dashboards

  accepts_nested_attributes_for :flow_dashboards,
    reject_if: lambda {|r| r['dashboard_id'].blank? },
    allow_destroy: true

  before_validation :populate_slug

  after_save :reposition_dasboards

private

  def populate_slug
    if self.slug.blank? && self.name.present?
      self.slug = self.name.downcase.gsub(/([^a-z0-9_\-_]+)/, '_')
    end
  end

  def reposition_dasboards
    self.flow_dashboards.sort do |a,b|
      [a.position, a.updated_at] <=> [b.position, b.updated_at] 
    end.each_with_index do |dashboard, i|
      dashboard.update(position: i)
    end
  end

end
