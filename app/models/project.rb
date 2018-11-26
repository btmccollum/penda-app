class Project < ApplicationRecord
    belongs_to :client, class_name: 'User'
    belongs_to :business, class_name: 'User'
    has_one :contract
    has_many :comments
end
