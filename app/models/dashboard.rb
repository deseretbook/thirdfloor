class Dashboard < ActiveRecord::Base
  validates_uniqueness_of :slug
  validates_presence_of :name, :slug
  before_validation :populate_slug

  after_save :reposition_cells, :narrow_cells
  
  has_many :dashboard_cells,
    dependent: :destroy
    
  accepts_nested_attributes_for :dashboard_cells,
    reject_if: lambda {|r| r["visualization_id"].blank? },
    allow_destroy: true

  has_many :visualizations, through: :dashboard_cells

  after_initialize -> { attributes["columns"] ||= 1 }

  def widen!(amount = 1)
    if columns < 5
      update!(columns: columns + amount)
    end
    columns
  end

  def narrow!(amount = 1)
    if columns > 1
      if amount >= columns
        update!(columns: 1)
      else
        update!(columns: columns - amount)
      end
    end
    narrow_cells
    columns
  end

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

  def narrow_cells
    self.dashboard_cells.each do |cell|
      if cell.columns > columns
        cell.update!(columns: columns)
      end
    end
  end
end
