class StationsController < ApplicationController
  respond_to :html, :json

  before_filter :login_required

  def index # GET collection
    stations = Station.all

    respond_with(stations) do |format|
      format.html { render locals: { stations: stations } }
    end
  end

  def show # GET member
    respond_with(station) do |format|
      format.html { render locals: { station: station } }
    end
  end

  def edit # GET member
  end

  def destroy # DELETE member
    station.destroy
    redirect_to stations_url, notice: 'Station was successfully destroyed.'
  end

  def create # POST collection
    station = Dashboard.new(dashboard_params)

    if station.save
      redirect_to station, notice: 'Dashboard was successfully created.'
    else
      render action: 'new'
    end
  end

  def update # PATCH/PUT member
    if station.update(station_params)
      redirect_to station, notice: 'Station was successfully updated.'
    else
      render action: 'edit'
    end
  end


  def station
    @station ||= Station.find(params[:id])
  end
  helper_method :station

private

  # Only allow a trusted parameter "white list" through.
  def station_params
    params.require(:station).permit(
      :hostname, :password, :location, :enabled
    )
  end

end
