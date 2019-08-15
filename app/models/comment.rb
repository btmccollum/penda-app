class Comment < ApplicationRecord
  belongs_to  :project
  belongs_to  :user
  belongs_to  :timeentry, optional: true

  validates   :content, presence: true, length: { in: 1..140, too_long: "Messages cannot be longer than 140 characters." }

  scope :last_ten_comments, ->(p) { where(project_id: p.id).order("created_at DESC").limit(10) }

  def time_created
    self.created_at.strftime("%A, %d %b %Y %l:%M %p")
  end
end
