class DashboardCell < ActiveRecord::Base
  belongs_to :dashboard
  belongs_to :visualization
  default_scope -> { order('id, position ASC') }
end
