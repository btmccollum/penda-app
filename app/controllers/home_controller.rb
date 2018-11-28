class HomeController < ApplicationController
  # before_action :authenticate_user!

  def front         
    @user = current_user
  end

  def dashboard
  end
end
