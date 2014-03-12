class UserLocationsController < ApplicationController
  respond_to :html, :json

  skip_before_filter :verify_authenticity_token, only: :create

  def index # GET collection
    user_locations = User.where(track_location: true).order('first_name, last_name').map do |user|
      user.user_locations.first
    end.compact

    respond_with(user_locations: user_locations) do |format|
      format.html do
        render(
          locals: { user_locations: user_locations },
          layout: choose_correct_template
        )
      end
    end
  end

  def create # POST collection
    
    params.permit(:user_ids)

    user_ids = (params[:user_ids] || []) # allow a station to send empty list
    user_ids.each do |user_id|
      user = User.find(user_id)
      UserLocation.create!( station_id: current_station.id, user_id: user.id)
    end
    respond_with_success(created: user_ids.size)
  end

end
