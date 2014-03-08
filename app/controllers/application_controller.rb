class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :cors_set_access_control_headers

  def current_station
    @current_station ||= begin
      params.require(:station)
      station = Station.where(
        hostname: params[:station][:hostname],
        password: params[:station][:password]
      ).first!
      
      station.communicated!(params[:station][:ip])
      
      station
    end
  end

protected

  def respond_with_success(options = {})
    respond_with( { status: :ok }.merge(options), status: :ok, location: nil)
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin']      = '*'
    headers['Access-Control-Allow-Methods']     = 'GET, OPTIONS'
    headers['Access-Control-Max-Age']           = '1728000'
    headers['Access-Control-Allow-Credentials'] = 'true'
  end


end
