class Comment < ApplicationRecord
    belongs_to :project
    belongs_to :user
    belongs_to :timeentry, optional: true

    validates :content, presence: true, length: { in: 1..50, too_long: "Messages cannot be longer than 50 characters." }

    scope :last_ten_comments, ->(p) { where(project_id: p.id).order("created_at DESC").limit(10) }
end
