class ProjectsController < ApplicationController
    before_action :has_permission?, except: %i[index show]

    def new
        @project = Project.new
    end
    
    def create
        @project = Project.create(project_params)
    end

    private

        def project_params
            params.require(:project).permit(:title, :business_id, :client_id)
        end
end
