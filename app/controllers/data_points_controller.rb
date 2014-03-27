class DataPointsController < ApplicationController
  respond_to :html, :json

  skip_before_filter :verify_authenticity_token, only: [ :create, :named_route_create ]

  # before_filter :login_required, only: [ :index, :show ]

  def index # GET collection
    respond_with(
      cached_data_points,
      each_serializer: DataPointSerializer
    ) do |format|
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
    respond_with(point, serializer: DataPointSerializer, root: false) do |format|
      format.html { render text: point.to_json }
    end
  end

protected

  def data_points
    DataPoint.where(id_condition).where(name_condition).where(days_condition)
  end

  def cached_data_points
    Rails.cache.fetch(data_points.limit(limit_condition).to_sql, expires_in: 5.minutes) do
      data_points.limit(limit_condition).to_a
    end
  end

private

  def limit_condition
    if (l = params[:limit].to_i) > 0
      l
    else
      nil
    end
  end

  def name_condition
    {}.tap do |h|
      if (name = params[:name]).present?
        h[:name] = name
      end
    end
  end

  def days_condition
    [].tap do |a|
      if (days = params[:days]).present?
        a << "created_at >= now() - interval '? days'"
        a << days.to_i
      end
    end
  end

  def id_condition
    {}.tap do |h|
      if params[:id]
        h[:id] = params[:id]
      end
    end
  end
end
