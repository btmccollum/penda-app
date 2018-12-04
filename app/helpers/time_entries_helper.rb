module TimeEntriesHelper
    def time_duration(time)
        start_time = time.start_time.to_f    
        end_time = time.end_time.to_f
        total = ((end_time - start_time)).round(2)

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