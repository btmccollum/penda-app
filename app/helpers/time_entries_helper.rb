module TimeEntriesHelper
    def time_duration(time)
        total = time.duration.to_f

        if total >= 3600
            new_total = ((total / 60) / 60).round(2)
            "#{new_total} Hours"
        elsif total >= 60 && total < 3600
            new_total = (total / 60).round(2)
            "#{new_total} Minutes"
        else
            "#{total} Seconds"
        end
    end

    def current_time
        Time.zone.now.strftime("%I:%M:%S %p")
    end

    def normalized_start
        @time_entry.start_time.strftime("%I:%M:%S %p") unless @time_entry.start_time.nil?
    end

    def normalized_end
        @time_entry.end_time.strftime("%I:%M:%S %p") unless @time_entry.end_time.nil?
    end

    def current_user_created?
        @time_entry.user_id == current_user.id
    end
end