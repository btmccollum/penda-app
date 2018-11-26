class ApplicationController < ActionController::Base
    devise_group :user, contains: [:client, :business]

    protect_from_forgery with: :exception
    before_action :authenticate_user!
end
