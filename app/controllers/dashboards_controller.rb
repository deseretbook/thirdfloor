class DashboardsController < ApplicationController
  before_action :set_dashboard

  before_filter :login_required

  # GET /dashboards
  def index
    @dashboards = Dashboard.all
  end

  # GET /dashboards/1
  def show
  end

  # GET /dashboards/new
  def new
    @dashboard = Dashboard.new
  end

  # GET /dashboards/1/edit
  def edit
    @dashboard.dashboard_cells.build
  end

  # POST /dashboards
  def create
    @dashboard = Dashboard.new(dashboard_params)

    if @dashboard.save
      redirect_to @dashboard, notice: 'Dashboard was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /dashboards/1
  def update
    if @dashboard.update(dashboard_params)
      redirect_to @dashboard, notice: 'Dashboard was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def add_visualization
    visualization = Visualization.where(id: params[:visualization_id]).first!
    if visualization.disabled?
      render text: 'visualization not enabled', status: :unacceptable
    else
      if @dashboard.dashboard_cells.create(visualization: visualization, position: 99)
        @dashboard.reposition_cells
        render text: 'ok', status: :ok
      else
        render text: 'problem adding visualization', status: :unacceptable
      end
    end
  end

  def remove_visualization
    cell = @dashboard.dashboard_cells.where(id: params[:dashboard_cell_id]).first!
    cell.destroy if cell
    @dashboard.reposition_cells
    render text: 'ok', status: :ok
  end

  # DELETE /dashboards/1
  def destroy
    @dashboard.destroy
    redirect_to dashboards_url, notice: 'Dashboard was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dashboard
      if (id = params[:id]).present?
        @dashboard = Dashboard.find(id)
      end
    end

    # Only allow a trusted parameter "white list" through.
    def dashboard_params
      params.require(:dashboard).permit(
        :name, :slug, :enabled, :refresh, :css, :columns,
        dashboard_cells_attributes: [ :id, :dashboard_id, :visualization_id, :columns, :position, :_destroy ]
      )
    end
end
