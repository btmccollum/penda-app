class SessionsController < ApplicationController
    before_action :signed_in?, only: %i[destroy]
    before_action :already_signed_in?, only: %i[new create]
    layout "welcome_screen", only: %i[new]

    def new
    end

    def create
        if auth && !existing_oauth_user? #oauth login for new user
            @user = User.create_from_oauth(auth)
            establish_session
        
            flash[:notice] = "Welcome to Penda! It looks like you haven't created an account with us before so we got you started with a basic client account! If you would like to register as a business user, please log out and create a business account."
            redirect_to dashboard_path
        elsif auth && existing_oauth_user? #oauth login for existing user
            @user = User.locate_by_oauth(auth)
            establish_session

            flash[:notice] = "Signed in!"
            redirect_to dashboard_path
        else #normal login
            @user = User.find_by(email: params[:email])
            if @user && @user.authenticate(params[:password])
                establish_session

                flash[:notice] = "Signed in!"
                redirect_to dashboard_path
            else 
                flash[:alert] = "Invalid credentials."
                redirect_to root_path
            end
        end
    end

    def destroy
        reset_session

        flash[:notice] = "Successfully logged out."
        redirect_to root_path
    end

    def failure
        flash[:alert] = "There was an issue authenticating your account. Please try again."
        redirect_to root_path
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

    def establish_session
        reset_session
        session[:user_id] = @user.id
    end
end
