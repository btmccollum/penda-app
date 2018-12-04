class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception, prepend: true

private

    def current_user
        return unless session[:user_id]
        @current_user ||= User.find(session[:user_id])
    end

    def signed_in?
        unless current_user
            redirect_to 'sessions/new', flash[:danger] = "Please log in."
        end
    end

    def user_is_owner?
        if params[:id].to_i != current_user.id
            redirect_to root_path, flash[:alert] = "Unauthorized Access."
        end
    end

    def has_permission? #authorization for access
        unless current_user.class.name == "Business" || current_user.class.name == "Client"
            flash[:alert] = "Unauthorized Access." 
            if current_user
                redirect_to dashboard_path
            else
                redirect_to root_path
            end
        end
    end

    def business_user?
        current_user.class.name == "Business"
    end
end
