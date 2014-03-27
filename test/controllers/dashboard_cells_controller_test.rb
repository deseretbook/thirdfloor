require 'test_helper'

class DashboardCellsControllerTest < ActionController::TestCase
  setup do
    @dashboard_cell = dashboard_cells(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dashboard_cells)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dashboard_cell" do
    assert_difference('DashboardCell.count') do
      post :create, dashboard_cell: { columns: @dashboard_cell.columns, dashboard_id: @dashboard_cell.dashboard_id, position: @dashboard_cell.position, rows: @dashboard_cell.rows, visualization_id: @dashboard_cell.visualization_id }
    end

    assert_redirected_to dashboard_cell_path(assigns(:dashboard_cell))
  end

  test "should show dashboard_cell" do
    get :show, id: @dashboard_cell
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dashboard_cell
    assert_response :success
  end

  test "should update dashboard_cell" do
    patch :update, id: @dashboard_cell, dashboard_cell: { columns: @dashboard_cell.columns, dashboard_id: @dashboard_cell.dashboard_id, position: @dashboard_cell.position, rows: @dashboard_cell.rows, visualization_id: @dashboard_cell.visualization_id }
    assert_redirected_to dashboard_cell_path(assigns(:dashboard_cell))
  end

  test "should destroy dashboard_cell" do
    assert_difference('DashboardCell.count', -1) do
      delete :destroy, id: @dashboard_cell
    end

    assert_redirected_to dashboard_cells_path
  end
end
