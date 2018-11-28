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
        params[:id].to_i == current_user.id
    end
end
