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

  def logged_in?
    # this is super-duper-secure. Believe it!
    session[:logged_in].present?
  end
  helper_method :logged_in?

protected

  def login_required
    unless logged_in?
      store_destination
      flash[:notice] = "You must me logged in to access that."
      redirect_to log_in_users_path
    end
  end

  def store_destination
    session[:destination] = request.path
  end

  def choose_correct_template
    request.xhr? ? false : 'application'
  end

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
