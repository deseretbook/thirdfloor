module ApplicationHelper
  def render_visualization(slug)
    if vis = Visualization.find_by_slug(slug)
      render inline: vis.markup, type: vis.markup_type
    else
      render text: "Visualization '#{slug}' not found."
    end
  end

  def autohide_menu?
    request.path == '/'  || request.path =~ /^\/dashboard\//
  end
end
