class StationSerializer < ActiveModel::Serializer
  attributes :id, :hostname, :location, :enabled, :last_seen_at, :last_ip_address, :local
end
