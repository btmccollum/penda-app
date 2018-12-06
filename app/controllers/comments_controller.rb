class CommentsController < ApplicationController
    before_action :signed_in?, only: %i[index create destroy]
    before_action :comment_owner?, only: %i[edit destroy]

    def index
        @project = Project.find(params[:project_id])
    end

    def create
        @project = Project.find(comment_params[:project_id])
        @comment = @project.comments.create(comment_params)
        if @comment.valid?
            redirect_back(fallback_location: project_path(@project))
        else
            render 'projects/show'
        end
    end

    def destroy
        @comment = Comment.find(params[:id])
        @comment.destroy

        flash[:notice] = "Comment successfully removed."
        redirect_back(fallback_location: dashboard_path)
    end

    private

    def comment_params
        params.require(:comment).permit(:project_id, :user_id, :content)
    end

    def comment_owner?
        @comment = Comment.find(params[:id])
        current_user.id == @comment.user_id
    end

end
