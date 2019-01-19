class TimeEntrySerializer < ActiveModel::Serializer
  attributes :id, :project_id, :start_time, :end_time, :finished, :created_at, :updated_at, :title, :duration, :user_id
  belongs_to :project
  has_many :comments
end
