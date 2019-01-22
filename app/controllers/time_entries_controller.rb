class TimeEntriesController < ApplicationController
    before_action :signed_in?
    before_action :is_resource_owner?, only: %i[edit update destroy]

    def index
        @project = Project.find(params[:project_id])
        respond_to do |f|
            f.html
            f.json {render json: @project}
        end
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
            @time_entry.save

            redirect_to project_path(@time_entry.project)
        else
            render :edit
        end
    end

    def destroy
        time_entry = TimeEntry.find(params[:id])
        time_entry.destroy

        flash[:notice] = "Time entry was successfully removed."
        redirect_to project_path(params[:project_id])
    end

    private

    def time_entry_params
        params.require(:time_entry).permit(:project_id, :user_id, :title, :start_time, :end_time, :duration, :content)
    end

end
