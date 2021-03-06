class CommentsController < ApplicationController
    before_action :signed_in?, only: %i[index create destroy]
    before_action :is_resource_owner?, only: %i[destroy]

    def index
        @project = Project.find(params[:project_id])
    end

    def create
        @comment = Comment.new(comment_params)
        if @comment.save
            respond_to do |f|
                f.html {redirect_back(fallback_location: project_path(@comment.project_id))}
                f.json {render :json => { 
                    comment: @comment, 
                    user: @comment.user
                    }
                }
            end
        else
            @project = Project.find(comment_params[:project_id])
            render 'projects/show'
        end
    end

    def destroy
        comment = Comment.find(params[:id])
        @project = Project.find(comment.project_id)
        comment.destroy
        
        flash[:notice] = "Comment successfully removed."
        
        respond_to do |f|
            f.html { }
            f.json { }
        end
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
