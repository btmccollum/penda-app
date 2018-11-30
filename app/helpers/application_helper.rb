module ApplicationHelper
    def has_permission? #authorization for business only
        current_user.class.name == "Business"
    end

    def current_user
        return unless session[:user_id]
        @current_user ||= User.find(session[:user_id])
    end

end