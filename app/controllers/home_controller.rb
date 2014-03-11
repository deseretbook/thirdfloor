class HomeController < ApplicationController
  def visualize
    vis = Visualization.where(slug: params[:slug], enabled: true).first!
    render(
      layout: choose_correct_template,
      inline: vis.markup,
      type: vis.markup_type,
      locals: { visualization: vis }
    )
  end
end
