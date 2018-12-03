class TimeEntry < ApplicationRecord
    belongs_to :project
    has_many :comments

    validate :start_time, presence: true
    validate :end_time, presence: true
end
