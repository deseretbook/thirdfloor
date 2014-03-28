class Dashboard < ActiveRecord::Base
  validates_uniqueness_of :slug
  validates_presence_of :name, :slug
  
  has_many :dashboard_cells,
    dependent: :destroy
    
  accepts_nested_attributes_for :dashboard_cells,
    reject_if: lambda {|r| r["visualization_id"].blank? },
    allow_destroy: true

  has_many :visualizations, through: :dashboard_cells
end
