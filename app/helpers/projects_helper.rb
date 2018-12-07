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

    def permitted_to_take_action?
        (@project.business_id && current_user.type == "Business") || (@project.business_id.nil? && current_user.type == "Client")
    end

    def recent_comments
        Comment.last_ten_comments(@project)
    end

    def professional_use?
        business_user? || @project.business_id
    end

    def business_full_name
        @project.business.full_name
    end

    def client_full_name
        @project.client.full_name
    end

    def project_has_time_entries?
        @project.time_entries.exists?
    end

    def project_has_comments?
        @project.comments.exists?
    end
end
