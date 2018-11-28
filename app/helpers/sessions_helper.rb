module SessionsHelper
    def signed_in?
        !!session[:user_id]
    end

    def client_signed_in?
        if signed_in? && current_user.type = "Client"
            true
        end
    end

    def business_signed_in?
        if signed_in? && current_user.type = "Business"
            true
        end
    end

    def current_user
        return unless session[:user_id]
        @current_user ||= User.find(session[:user_id])
    end
end
