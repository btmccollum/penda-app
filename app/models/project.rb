class Project < ApplicationRecord
    belongs_to :client, class_name: 'User'
    belongs_to :business, class_name: 'User'
    has_one :contract
    has_many :comments

    def last_updated
        self.updated_at.strftime("%A, %d %b %Y %l:%M %p")
    end
end
