class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id, :project_id, :created_at, :updated_at
  belongs_to :project
  belongs_to :time_entry
end
