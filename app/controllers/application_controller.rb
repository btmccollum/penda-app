class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception, prepend: true

private

    def current_user
        return unless session[:user_id]
        @current_user ||= User.find(session[:user_id])
    end

    def signed_in?
        unless !!current_user
            flash[:alert] = "Please log in."
            redirect_to login_path
        end
    end

    def already_signed_in?
        if !!current_user
            flash[:notice] = "You are already signed in."
            redirect_to dashboard_path
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

    def is_owner?
        r = self.class.name.gsub('Controller', '').downcase.singularize
        r_id = params[:id]
        resource = (r.capitalize.constantize).find(r_id)

        if current_user.id == resource.id
            true
        else
            flash[:alert] = "Unauthorized Access."
            if signed_in?
                redirect_to dashboard_path
            else
                redirect_to root_path
            end
        end
    end

    def is_resource_owner?        
        r = self.class.name.gsub('Controller', '').singularize
        r_id = params[:id]
        resource = (r.constantize).find(r_id)

        if current_user.id == resource.user_id
            true
        else
            flash[:alert] = "Unauthorized Access."
            if signed_in?
                redirect_to dashboard_path
            else
                redirect_to root_path
            end
        end
    end
end
