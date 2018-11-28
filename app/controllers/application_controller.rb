class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception, prepend: true
    # skip_before_action :verify_authenticity_token 

    devise_group :user, contains: [:client, :business]

    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

        def configure_permitted_parameters
            devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid) }
            
            devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type) }
        end

        def after_sign_out_path_for(resource_or_scope)
            root_path
        end
end
