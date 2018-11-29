class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception, prepend: true

private

    def current_user
        return unless session[:user_id]
        @current_user ||= User.find(session[:user_id])
    end

    def signed_in?
        unless current_user
            flash[:danger] = "Please log in."
            redirect_to 'sessions/new'
        end
    end

    def user_is_owner?
        if params[:id].to_i != current_user.id
            flash[:alert] = "Unauthorized Access."
            redirect_to root_path
        end
    end

    def has_permission? #authorization for business only
        unless current_user.class.name == "Business"
            flash[:alert] = "Unauthorized Access." 
            signed_in? ? (redirect_to dashboard_path) : (redirect_to root_path)
        end
    end
end
