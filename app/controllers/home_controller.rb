class HomeController < ApplicationController
  before_action :signed_in?, only: %i[dashboard]
  before_action :already_signed_in?, only: %i[front choice]
  layout "welcome_screen", only: %i[front choice activity]

  def front         
  end

  def choice
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

  def activity
    @list = User.most_recently_active
  end  
end
