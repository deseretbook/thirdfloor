class HomeController < ApplicationController
  respond_to :html, :json, :js, :text
  skip_before_action :verify_authenticity_token, only: :visualize # allow xss

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
