class SessionsController < ApplicationController
    def new
    end

    def create
        if auth #omniauth login
            session.clear
            @user = User.find_or_create_by(email: auth[:info][:email]) do |u|
                u.username = auth[:info][:email]
                u.email = auth[:info][:email]
                u.first_name = auth[:info][:name].split(" ").first
                u.last_name = auth[:info][:name].split(" ").last
                u.password = User.generated_password
                u.password_confirmation = u.password
                u.type = "Client"
                u.provider = auth[:provider]
                u.uid = auth[:uid]
                # u.image = auth['info']['image']
            end
            session[:user_id] = @user.id
                    
            redirect_to root_path
        else #normal login
            session.clear
            @user = User.find_by(email: params[:email])
            if @user && @user.authenticate(params[:password])
                session[:user_id] = @user.id
                redirect_to root_path
            else 
                redirect_to root_path, alert: "Invalid credentials."
            end
        end
    end

    def destroy
        session.clear
    
        redirect_to root_path
    end

    private

    def auth
        request.env["omniauth.auth"]
    end
    
    def failure
        raise params.inspect
    end

        # def resource_params
        #     params.require(:client).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid)
        # end

        # def sign_in_params
        #     params.permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid)
        # end
    # end
end
