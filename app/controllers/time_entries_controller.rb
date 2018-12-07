class TimeEntriesController < ApplicationController
    before_action :signed_in?

    def index
        @project = Project.find(params[:project_id])
    end

    def show
        @project = Project.find(params[:project_id])
        @time_entry = TimeEntry.find(params[:id])
    end
    
    def new
        project = Project.find(params[:project_id])
        @time_entry = project.time_entries.build
    end

    def create
        @time_entry = TimeEntry.new_from_params(time_entry_params)
        if @time_entry.save
            flash[:notice] = "Entry Successfully Added."
            redirect_to project_path(@time_entry.project)
        else
            render :new
        end
    end

    def edit
        @project = Project.find(params[:project_id])
        @time_entry = TimeEntry.find(params[:id])
    end

    def update
        @time_entry = TimeEntry.find(params[:id])
        @time_entry.assign_attributes(time_entry_params)
        if @time_entry.valid?
            @time_entry.update(time_entry_params)
            @time_entry.duration = @time_entry.total_time
            
            redirect_to project_path(@time_entry.project)
        else
            render :edit
        end
    end

    def destroy
    end

    private

    def time_entry_params
        params.require(:time_entry).permit(:project_id, :title, :start_time, :end_time, :duration, :content)
    end

end
