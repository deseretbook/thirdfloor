class HomeController < ApplicationController


  def visualize
    render template: "home/#{params[:name]}"
  end
end
