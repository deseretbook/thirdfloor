class Dashboard < ActiveRecord::Base
  validates_uniqueness_of :slug
  validates_presence_of :name, :slug
  
  has_many :dashboard_cells
  has_many :visualizations, through: :dashboard_cells
end
