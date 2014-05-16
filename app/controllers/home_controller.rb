class HomeController < ApplicationController
  respond_to :html, :json, :js, :text
  skip_before_action :verify_authenticity_token, only: :visualize # allow xss

  def index
    redirect_to action: :default_dashboard
  end

  def visualize
    vis = Visualization.where(slug: params[:slug], enabled: true).first!
    render(
      layout: choose_correct_template,
      # inline: vis.markup,
      # type: vis.markup_type,
      locals: { visualization: vis }
    )
  end

  def dashboard
    slug = params[:slug]
    # get dashboard by slug or id
    dashboard = if slug =~ /^\d+/
      Dashboard.enabled.where(id: slug.to_i).first!
    else
      Dashboard.enabled.where(slug: params[:slug]).first!
    end
    render locals: { dashboard: dashboard }
  end

  def default_dashboard
    redirect_to(
      render_dashboard_path(
        Dashboard.enabled.first!.slug
      )
    )
  end
end
