module SessionsHelper
    def signed_in?
        !!session[:user_id]
    end

    def app_current_user
        User.find(session[:user_id])
    end
end
