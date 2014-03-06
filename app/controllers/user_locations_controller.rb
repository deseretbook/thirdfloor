class UserLocationsController < ApplicationController
  respond_to :html, :js, :json, :text

  skip_before_filter :verify_authenticity_token


  def index # GET collection
    user_locations = User.where(track_location: true).map do |user|
      [ user, user.user_locations.last ]
    end

    respond_with(user_locations: user_locations) do |format|
      format.html { render locals: { user_locations: user_locations } }
    end
  end

  def create # POST collection
    
    params.permit(:user_ids)
    
    current_station.communicated!(params[:station][:ip])

    user_ids = (params[:user_ids] || []) # allow a station to send empty list
    user_ids.each do |user_id|
      user = User.find(user_id)
      UserLocation.create!( station_id: current_station.id, user_id: user.id)
    end
    respond_with_success(created: user_ids.size)
  end

  def respond_with_success(options = {})
    respond_with( { status: :ok }.merge(options), status: :ok, location: nil)
  end

private

  def current_station
    @current_station ||= begin
      params.require(:station)
      Station.where(
        hostname: params[:station][:hostname],
        password: params[:station][:password]
      ).first!
    end
  end

end
