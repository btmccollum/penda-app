class Comment < ApplicationRecord
    belongs_to :project
    belongs_to :user
    belongs_to :timeevent, optional: true
end
