class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_station
    @current_station ||= begin
      params.require(:station)
      station = Station.where(
        hostname: params[:station][:hostname],
        password: params[:station][:password]
      ).first!
      if params[:station][:ip]
        station.communicated!(params[:station][:ip])
      end
      station
    end
  end

protected

  def respond_with_success(options = {})
    respond_with( { status: :ok }.merge(options), status: :ok, location: nil)
  end

end
