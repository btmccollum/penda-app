class TimeEntry < ApplicationRecord
    belongs_to :project
    has_many :comments

    validates :start_time, presence: true
    validates :end_time, presence: true
end
