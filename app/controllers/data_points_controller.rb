class DataPointsController < ApplicationController
  respond_to :html, :json

  skip_before_filter :verify_authenticity_token, only: [ :create, :named_route_create ]

  def index # GET collection
    respond_with(data_points: cached_data_points) do |format|
      format.html do
        render locals: {
          data_points: data_points.paginate(:page => params[:page])
        }
      end
    end
  end

  def create # POST collection
    
    params.require(:name)
    params.permit(:data)

    data = (params[:data] || {}) # allow a station to send no data
    
    respond_with(DataPoint.create!(
      name: params[:name],
      station_id: current_station.id,
      data: data
    ))
  end

  # allows data points to be creates from anything that posts data
  def named_route_create
    respond_with(DataPoint.create!(
      name: params[:name],
      station_id: Station.local_station.id,
      data: params.merge(remote_ip: request.remote_ip)
    ))
  end

  def show
    point = DataPoint.find(params[:id])
    respond_with(data_point: point) do |format|
      format.html { render text: point.to_json }
    end
  end

  def limit_param
    params.permit(:limit)
    if (limit_str = params[:limit]).present?
      limit_str.to_i
    else
      nil
    end
  end
  helper_method :limit_param

  def name_param
    params[:name]
  end
  helper_method :name_param

  def days_param
    params[:days]
  end
  helper_method :days_param

protected

  def data_points
    DataPoint.where(name_condition).where(days_condition)
  end

  def cached_data_points
    Rails.cache.fetch(data_points.limit(limit_condition).to_sql, expires_in: 5.minutes) do
      data_points.limit(limit_condition).to_a
    end
  end

private

  def limit_condition
    if (l = limit_param.to_i) > 0
      l
    else
      nil
    end
  end

  def name_condition
    {}.tap do |h|
      if name = name_param
        h[:name] = name
      end
    end
  end

  def days_condition
    [].tap do |a|
      if days_param.present?
        a << "created_at >= now() - interval '? days'"
        a << days_param.to_i
      end
    end
  end
end
