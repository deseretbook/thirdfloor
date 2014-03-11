class HomeController < ApplicationController
  def visualize
    if vis = Visualization.find_by_slug(params[:slug])
      @virtual_path = "visualize/#{params[:slug]}"
      render(
        inline: vis.markup,
        type: vis.markup_type,
        virtual_path: @virtual_path,
        locals: { visualization: vis }
      )
    else
      render template: "home/#{params[:slug]}"
    end
  end
end
