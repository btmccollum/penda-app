class HomeController < ApplicationController
  before_action :signed_in?, only: %i[dashboard]

  def front         
    @user = current_user
  end

  def dashboard
    if params[:status] == "active"
      @projects = Project.active_projects(current_user)
    elsif params[:status] == "completed"
      @projects = Project.completed_projects(current_user)
    else
      @projects = current_user.projects
    end
  end
end
