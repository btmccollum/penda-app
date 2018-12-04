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
end