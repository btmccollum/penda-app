class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception, prepend: true
    # skip_before_action :verify_authenticity_token 

    # devise_group :user, contains: [:client, :business]

    # before_action :configure_permitted_parameters, if: :devise_controller?
private

    def current_user
        return unless session[:user_id]
        @current_user ||= User.find(session[:user_id])
    end

    def signed_in?
            !!session[:user_id]
    end
end
