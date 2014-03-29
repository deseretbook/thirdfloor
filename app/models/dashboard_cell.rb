class DashboardCell < ActiveRecord::Base
  belongs_to :dashboard
  belongs_to :visualization
  default_scope -> { order('position, updated_at ASC') }

  before_save -> do
    self.columns = 1 if self.columns.blank?
  end

  def widen!(amount = 1, widen_dashboard: true)
    update!(columns: (columns.nil? ? 1 : columns ) + amount)
    if widen_dashboard
      if dashboard.columns < columns
        dashboard.widen!(columns)
      end
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
    columns
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
