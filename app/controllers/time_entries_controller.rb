class TimeEntriesController < ApplicationController
    before_action :signed_in?
    
    def new
        project = Project.find(params[:project_id])
        @time_entry = project.time_entries.build
    end

    def create
        project = Project.find(time_entry_params[:project_id])
        time_entry = project.time_entries.build(time_entry_params)
        time_entry.end_time = Time.now.strftime("%I:%M:%S %p")
        time_entry.finished = true
        time_entry.save

        redirect_to project_path(time_entry.project)
    end

    private

    def time_entry_params
        params.require(:time_entry).permit(:project_id, :title, :start_time, :end_time, :content)
    end

end