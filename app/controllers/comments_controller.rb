class CommentsController < ApplicationController
    before_action :signed_in?, only: %i[index create edit destroy]

    def index
        @project = Project.find(params[:project_id])
    end

    def create
        project = Project.find(comment_params[:project_id])
        @comment = project.comments.create(comment_params)
        if @comment.valid?
            redirect_back(fallback_location: project_path(project))
        else
            @comment.errors.map {|x,y| flash[:alert] = "Message #{x.to_s} #{y}" }
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
