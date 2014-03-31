class DashboardCellSerializer < ActiveModel::Serializer
  attributes :id, :dashboard_id, :visualization_id, :rows, :columns, :position
end
