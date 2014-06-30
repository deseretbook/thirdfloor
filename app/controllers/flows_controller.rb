class FlowsController < ApplicationController
  before_action :set_flow, only: [:show, :edit, :update, :destroy]

  before_filter :login_required

  # GET /flows
  def index
    @flows = Flow.all
  end

  # GET /flows/1
  def show
  end

  # GET /flows/new
  def new
    @flow = Flow.new
  end

  # GET /flows/1/edit
  def edit
    @flow.flow_dashboards.build # always have an empty form available
  end

  # POST /flows
  def create
    @flow = Flow.new(flow_params)

    if @flow.save
      redirect_to @flow, notice: 'Flow was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /flows/1
  def update
    if @flow.update(flow_params)
      redirect_to @flow, notice: 'Flow was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /flows/1
  def destroy
    @flow.destroy
    redirect_to flows_url, notice: 'Flow was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flow
      @flow = Flow.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def flow_params
      params.require(:flow).permit(:name, :slug, flow_dashboards_attributes: %i[ id dashboard_id flow_id _destroy refresh position ])
    end
end
