class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    devise_group :user, contains: [:client, :business]

    before_action :authenticate_user!, except: %i[home]
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

        def configure_permitted_parameters
            devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type) }
            devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type) }
        end
end
