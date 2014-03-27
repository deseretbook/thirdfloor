class DashboardCellsController < ApplicationController
  before_action :set_dashboard_cell, only: [:show, :edit, :update, :destroy]

  # GET /dashboard_cells
  def index
    @dashboard_cells = DashboardCell.all
  end

  # GET /dashboard_cells/1
  def show
  end

  # GET /dashboard_cells/new
  def new
    @dashboard_cell = DashboardCell.new
  end

  # GET /dashboard_cells/1/edit
  def edit
  end

  # POST /dashboard_cells
  def create
    @dashboard_cell = DashboardCell.new(dashboard_cell_params)

    if @dashboard_cell.save
      redirect_to @dashboard_cell, notice: 'Dashboard cell was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /dashboard_cells/1
  def update
    if @dashboard_cell.update(dashboard_cell_params)
      redirect_to @dashboard_cell, notice: 'Dashboard cell was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /dashboard_cells/1
  def destroy
    @dashboard_cell.destroy
    redirect_to dashboard_cells_url, notice: 'Dashboard cell was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dashboard_cell
      @dashboard_cell = DashboardCell.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def dashboard_cell_params
      params.require(:dashboard_cell).permit(:dashboard_id, :visualization_id, :rows, :columns, :position)
    end
end
