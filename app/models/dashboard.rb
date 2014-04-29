class Dashboard < ActiveRecord::Base
  MAXIMUM_COLUMNS = 5 # arbitrary

  validates_uniqueness_of :slug
  validates_presence_of :name, :slug
  before_validation :populate_slug
  validates_format_of :slug, with: /\A[a-zA-Z]+/, message: "must begin with a-z"

  before_validation -> do
    if read_attribute(:columns).to_i > MAXIMUM_COLUMNS
      write_attribute(:columns, MAXIMUM_COLUMNS)
    end
  end
  validates_numericality_of :columns, maximum: MAXIMUM_COLUMNS

  after_save :reposition_cells
  
  has_many :dashboard_cells,
    dependent: :destroy
    
  accepts_nested_attributes_for :dashboard_cells,
    reject_if: lambda {|r| r["visualization_id"].blank? },
    allow_destroy: true

  has_many :visualizations, through: :dashboard_cells

  after_initialize -> { attributes["columns"] ||= 1 }

  scope :enabled, -> { where(enabled: true) }

  def reposition_cells
    self.dashboard_cells.sort do |a,b|
      [a.position, a.updated_at] <=> [b.position, b.updated_at] 
    end.each_with_index do |cell, i|
      cell.update(position: i)
    end
  end

private

  def populate_slug
    if self.slug.blank? && self.name.present?
      self.slug = self.name.downcase.gsub(/([^a-z0-9_\-_]+)/, '_')
    end
  end
end
