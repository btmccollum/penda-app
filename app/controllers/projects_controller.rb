class ProjectsController < ApplicationController
    before_action :signed_in?
    before_action :has_permission?, except: %i[index show]

    def show
        @project = Project.find(params[:id])
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
                
                render :new
            else
                project = Project.new
                project.title = project_params[:title]
                project.business_id = project_params[:business_id].to_i
                
                if business_user?
                    project_client = project.find_or_build_client_by(project_params[:client_attributes])
                    project.save
                else
                    project.save
                end
                flash[:notice] = "Project successfully created!"
                redirect_to project_path(project)
            end
        else
            project = Project.create(project_params)

            flash[:notice] = "Project successfully created!"
            redirect_to project_path(project)
        end
    end

    private

        def project_params
            params.require(:project).permit(:title, :client, :business_id, :client_id, client_attributes: [:first_name, :last_name, :email])
        end
end
