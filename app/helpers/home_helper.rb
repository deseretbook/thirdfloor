module HomeHelper
  def autoscroll_cell?(cell)
    return false if !cell.dashboard.autoscroll?
    cell.autoscroll?
  end
end
