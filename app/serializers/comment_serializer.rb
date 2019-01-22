class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id, :project_id, :created_at, :updated_at, :time_created
  belongs_to :project
  belongs_to :time_entry
end
