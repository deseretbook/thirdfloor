class DashboardCell < ActiveRecord::Base
  belongs_to :dashboard, touch: true
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

  def div_id
    "vc_#{id}"
  end

  def interpolation_values
    visualization.interpolation_values.merge(div_id: div_id)
  end
  
  # Return visualization#markup, but replace strings with data structures.
  # __READY_EVENT__   : name of the JS event signaling the page is ready.
  # __REFRESH_EVENT__ : name of the JS event signaling the vis should refresh.
  # __DIV_ID__        : DOM ID of the div containing the visualizartion.
  def interpolated_markup
    visualization.markup.tap do |markup|
      interpolation_values.each do |k,v|
        markup.gsub!("__#{k.upcase}__", v.to_s)
      end
    end
  end

  def markup_type
    visualization.markup_type
  end

end
