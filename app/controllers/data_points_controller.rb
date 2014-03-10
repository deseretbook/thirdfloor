class DataPointsController < ApplicationController
  respond_to :html, :js, :json, :text

  skip_before_filter :verify_authenticity_token, only: [ :create, :named_route_create ]

  def index # GET collection
    data_points = Rails.cache.fetch("dp_#{name_condition}_#{limit_condition}", expires_in: 2.minutes) do
      DataPoint.where(name_condition).limit(limit_condition).all.to_a
    end

    respond_with(data_points: data_points, name: name_param) do |format|
      format.html { render locals: { data_points: data_points, name: name_param } }
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

private

  def limit_param
    params.permit(:limit)
    params[:limit].to_i
  end

  def limit_condition
    if (l = limit_param) > 0
      l
    else
      nil
    end
  end

  def name_param
    params.permit(:name)
    params[:name]
  end

  def name_condition
    {}.tap do |h|
      if name = name_param
        h[:name] = name
      end
    end
  end

end
