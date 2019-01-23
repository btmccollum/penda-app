class ProjectsController < ApplicationController
    before_action :signed_in?
    before_action :has_permission?, except: %i[index show update]
    before_action :project_owner?, only: %i[update destroy]

    def show
        @project = Project.find(params[:id])
        @comment = Comment.new

        respond_to do |f|
            f.html
            f.json {render json: @project}
        end
    end

    def new
        @project = Project.new
        @project.build_client
    end
    
    def create 
        if project_params[:client_attributes]
            if project_params[:client_attributes].values.any? {|x| x.blank?}
                @project = Project.new(project_params)
                @project.add_form_errors
                
                # render :new
                respond_to do |f|
                    f.html {render :new}
                    f.json {render json: @project}
                end
            else
                @project = Project.new
                @project.title = project_params[:title]
                @project.business_id = project_params[:business_id].to_i
                
                if business_user?
                    @project_client = project.find_or_build_client_by(project_params[:client_attributes])
                    @project.save!
                else
                    @project.save!
                end
                flash[:notice] = "Project successfully created!"
                # redirect_to project_path(project)
                respond_to do |f|
                    f.html {redirect_to project_path(@project)}
                    f.json {render json: @project}
                end
            end
        else
            @project = Project.create(project_params)

            flash[:notice] = "Project successfully created!"
            # redirect_to project_path(project)
            respond_to do |f|
                f.html {redirect_to project_path(@project)}
                f.json {render json: @project}
            end
        end
    end

    def update
        project = Project.find(params[:id])
        project.update(status: "completed")
        
        redirect_to dashboard_path
    end

    def destroy
        @project = Project.find(params[:id])
        @project.destroy!

        flash[:notice] = "Project successfully removed."
        redirect_to dashboard_path
    end

    private

        def project_params
            params.require(:project).permit(:title, :client, :business_id, :client_id, client_attributes: [:first_name, :last_name, :email])
        end

        def project_owner?
            @project = Project.find(params[:id])
            @project.business_id == current_user.id || (@project.client_id == current_user.id && @project.business_id.nil?)
        end
end
