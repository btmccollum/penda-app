class CommentsController < ApplicationController
    before_action :signed_in?, only: %i[index create destroy]
    before_action :is_resource_owner?, only: %i[destroy]

    def index
        @project = Project.find(params[:project_id])
    end

    def create
        @comment = Comment.new(comment_params)
        if @comment.save
            redirect_back(fallback_location: project_path(@comment.project_id))
        else
            @project = Project.find(comment_params[:project_id])
            render 'projects/show'
        end
    end

    def destroy
        comment = Comment.find(params[:id])
        comment.destroy

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
