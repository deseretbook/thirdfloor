class StationsController < ApplicationController
  respond_to :html, :json

  def index # GET collection
    stations = Station.all

    respond_with(stations) do |format|
      format.html { render locals: { stations: stations } }
    end
  end

  def show # GET member
    station = Station.find(params[:id])
    respond_with(station) do |format|
      format.html { render locals: { station: station } }
    end
  end
end
