class DashboardSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :enabled, :refresh, :css, :cells
end
