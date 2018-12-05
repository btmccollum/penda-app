class CommentsController < ApplicationController
    before_action :signed_in?, only: %i[create edit destroy]
    
    def index
    end

    def create
        project = Project.find(comment_params[:project_id])
        if !comment_params[:content].blank?
            comment = project.comments.create(comment_params)
            redirect_back(fallback_location: project_path(project))
        else
            flash[:alert] = comment.errors.full_messages
            redirect_back(fallback_location: project_path(project))
        end
    end

    def edit
    end
    
    def update
    end

    def destroy
    end

    private

    def comment_params
        params.require(:comment).permit(:project_id, :user_id, :content)
    end

end
