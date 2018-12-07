class TimeEntry < ApplicationRecord
    belongs_to :project

    validates :title, presence: true
    validates :content, presence: true
    validates :start_time, presence: true
    validates :end_time, presence: true

    def total_time
        start_time = self.start_time.to_f    
        end_time = self.end_time.to_f
        total = ((end_time - start_time)).round(2).to_f
    end

    def self.new_from_params(params)
        time_entry = self.new(params).tap do |u|
            u.end_time = Time.zone.now.strftime("%I:%M:%S %p")
            u.duration = u.total_time
            u.finished = true
        end
    end
end
