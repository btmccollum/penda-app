class Comment < ApplicationRecord
    belongs_to :project
    belongs_to :user
    belongs_to :timeentry, optional: true
end
