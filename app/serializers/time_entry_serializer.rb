class TimeEntrySerializer < ActiveModel::Serializer
  attributes :id, :project_id, :start_time, :end_time, :finished, :created_at, :updated_at, :title, :content, :duration, :user_id, :total_time, :true_start_time, :true_end_time
  belongs_to :project
  has_many :comments
end
