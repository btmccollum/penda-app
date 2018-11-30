class ProjectsController < ApplicationController
    before_action :has_permission?, except: %i[index show]

    def show
        @project = Project.find(params[:id])
    end

    def new
        @project = Project.new
    end
    
    def create
        project = Project.new
        project.title = project_params[:title]
        project.business_id = project_params[:business_id].to_i
        
        unless project_params[:client].blank?
            project.client_id = Client.where(email: project_params[:client], type: "Client").first.id
        end

        project.save

        flash[:notice] = "Project successfully created!"
        redirect_to project_path(project)
    end

    private

        def project_params
            params.require(:project).permit(:title, :client_email, :client, :business_id, :client_id)
        end
end
