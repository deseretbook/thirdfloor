class DataPointsController < ApplicationController
  respond_to :html, :js, :json, :text

  skip_before_filter :verify_authenticity_token, only: :create

  def index # GET collection
    data_points = DataPoint.where(name_condition).all

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

  def show
    point = DataPoint.find(params[:id])
    respond_with(data_point: point) do |format|
      format.html { render text: point.to_json }
    end
  end

private

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
