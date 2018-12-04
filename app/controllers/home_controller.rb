class HomeController < ApplicationController
  before_action :signed_in?, only: %i[dashboard]

  def front         
    @user = current_user
  end

  def dashboard
    if params[:status] == "active"
      @projects = Project.by_user_active(current_user)
    elsif params[:status] == "completed"
      @projects = Project.by_user_completed(current_user)
    else
      @projects = current_user.projects
    end
  end
end
