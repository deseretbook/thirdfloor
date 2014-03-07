class StationsController < ApplicationController
  respond_to :html, :js, :json, :text

  def index # GET collection
    stations = Station.all

    respond_with(stations: stations) do |format|
      format.html { render locals: { stations: stations } }
    end
  end
end
