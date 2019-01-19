class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :client_id, :business_id, :title, :status, :created_at, :updated_at
  has_many :comments
  has_many :time_entries
end
