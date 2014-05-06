class Dashboard < ActiveRecord::Base
  validates_uniqueness_of :slug, case_sensitive: false
  validates_presence_of :name, :slug
  before_validation :populate_slug
  validates_format_of :slug, with: /\A[a-zA-Z]+/, message: "must begin with a-z"

  after_save :reposition_cells
  
  has_many :dashboard_cells,
    dependent: :destroy
    
  accepts_nested_attributes_for :dashboard_cells,
    reject_if: lambda {|r| r["visualization_id"].blank? },
    allow_destroy: true

  has_many :visualizations, through: :dashboard_cells

  scope :enabled, -> { where(enabled: true) }

  def reposition_cells
    self.dashboard_cells.sort do |a,b|
      [a.position, a.updated_at] <=> [b.position, b.updated_at] 
    end.each_with_index do |cell, i|
      cell.update(position: i)
    end
  end

  def maximum_height?
    maximum_height.present?
  end

  def maximum_width?
    maximum_width.present?
  end

  def maximum_x_cells
    return unless maximum_width?
    (((maximum_width - cell_x_margin) / ( cell_width + cell_x_margin))).to_i
  end

  # not yet used for anything. If you use this, check that is works first.
  def maximum_y_cells
    return unless maximum_height?
    ((maximum_height / ( cell_height + cell_y_margin))).to_i
  end

private

  def populate_slug
    if self.slug.blank? && self.name.present?
      self.slug = self.name.downcase.gsub(/([^a-z0-9\-_]+)/, '_')
    end
  end
end
