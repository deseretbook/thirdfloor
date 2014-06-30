class FlowDashboard < ActiveRecord::Base
  belongs_to :flow
  belongs_to :dashboard

  validates_presence_of :flow_id, :dashboard_id

  default_scope -> { order('position, updated_at ASC') }
  
end
