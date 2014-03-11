class HomeController < ApplicationController
  def visualize
    if vis = Visualization.find_by_slug(params[:slug])
      render(
        layout: choose_correct_template,
        inline: vis.markup,
        type: vis.markup_type,
        locals: { visualization: vis }
      )
    else
      render template: "home/#{params[:slug]}"
    end
  end
end
