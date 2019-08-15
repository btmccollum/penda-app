class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :client_id, :business_id, :title, :status, :created_at, :updated_at, :last_updated, :billable_hours, :total_hours
  has_many   :comments
  has_many   :time_entries
end
