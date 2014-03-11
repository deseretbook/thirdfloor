class DataPointsController < ApplicationController
  respond_to :html, :json

  DEFAULT_LIMIT = 10

  skip_before_filter :verify_authenticity_token, only: [ :create, :named_route_create ]

  def index # GET collection
    respond_with do |format|
      format.html do
        render locals: {
          data_points: DataPoint.where(name_condition).paginate(:page => params[:page])
        }
      end

      format.json { render json: cached_data_points }
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
      data: params
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
      DEFAULT_LIMIT
    end
  end
  helper_method :limit_param

  def name_param
    params.permit(:name)
    params[:name]
  end
  helper_method :name_param

protected

  def cached_data_points
    Rails.cache.fetch("data_points_#{name_param}_#{limit_param}", expires_in: 2.minutes) do
      DataPoint.where(name_condition).limit(limit_condition).to_a
    end
  end

private

  def limit_condition
    if (l = limit_param) > 0
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

end
