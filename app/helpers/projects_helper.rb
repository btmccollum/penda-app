module ProjectsHelper
    def project_total_hours(p)
        total = p.billable_hours

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

    def latest_entries
        Project.last_five(@project)
    end

    def permitted_to_add_entries?
        (@project.business_id && current_user.type == "Business") || (@project.business_id.nil? && current_user.type == "Client")
    end
end
