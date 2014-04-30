class VisualizationsController < ApplicationController
  before_action :set_visualization, only: [:show, :edit, :update, :destroy]

  before_filter :login_required

  # GET /visualizations
  def index
    @visualizations = Visualization.order('name')
  end

  # GET /visualizations/1
  def show
  end

  # GET /visualizations/new
  def new
    @visualization = Visualization.new
  end

  # GET /visualizations/1/edit
  def edit
  end

  # POST /visualizations
  def create
    @visualization = Visualization.new(visualization_params)

    if @visualization.save
      redirect_to @visualization, notice: 'Visualization was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /visualizations/1
  def update
    if @visualization.update(visualization_params)
      redirect_to @visualization, notice: 'Visualization was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /visualizations/1
  def destroy
    @visualization.destroy
    redirect_to visualizations_url, notice: 'Visualization was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visualization
      @visualization = Visualization.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def visualization_params
      params.require(:visualization).permit(:enabled, :name, :slug, :markup_type, :markup, :component)
    end
end
