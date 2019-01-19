class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :project_id, :created_at, :updated_at
  belongs_to :project
end
