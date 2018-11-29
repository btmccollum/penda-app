class SessionsController < ApplicationController
    before_action :already_signed_in?, only: %i[new create]

    def new
    end

    def create
        if auth && !existing_oauth_user? #oauth login for new user
            user = User.create_from_oauth(auth)
            reset_session
            session[:user_id] = user.id
                    
            redirect_to dashboard_path, notice: "Welcome to Penda! It looks like you haven't created an account with us before so we got you started with a basic client account! If you would like to register as a business user, please log out and create a business account."
        elsif auth && existing_oauth_user? #oauth login for existing user
            user = User.where(provider: auth[:provider], uid: auth[:uid]).first
            reset_session
            session[:user_id] = user.id

            redirect_to dashboard_path, notice: "Signed in!"
        else #normal login
            user = User.find_by(email: params[:email])
            if user && user.authenticate(params[:password])
                reset_session
                session[:user_id] = user.id

                redirect_to dashboard_path, notice: "Signed in!"
            else 
                redirect_to root_path, alert: "Invalid credentials."
            end
        end
    end

    def destroy
        reset_session
    
        redirect_to root_path
    end

    def failure
        redirect_to root_path, alert: "There was an issue authenticating your account. Please try again."
    end

    private

    def auth
        request.env["omniauth.auth"]
    end

    def existing_oauth_user?
        User.find_by(uid: auth[:uid])
    end
    
    def already_signed_in? 
        unless !current_user
            flash[:notice] = "You are already logged in."
            redirect_to dashboard_path
        end 
    end

end
