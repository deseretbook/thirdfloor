class DashboardCell < ActiveRecord::Base
  belongs_to :dashboard
  belongs_to :visualization
  default_scope -> { order('position, updated_at ASC') }

  def auto_refresh?
    visualization.data_point_name.present?
  end

  # default lower by 2 so it gets resorted properly
  def lower_position!(amount = 2)
    if position > 0
      update!(position: position - amount)
    end
    dashboard.reposition_cells
    position
  end

  def raise_position!(amount = 1)
    update!(position: position + amount)
    dashboard.reposition_cells
    position
  end
end
