class SessionsController < Devise::SessionsController
    # def new
    # end

    def create
        if auth #omniauth login
            @user = User.find_or_create_by(email: auth[:info][:email]) do |u|
                u.username = auth['info']['email']
                u.email = auth['info']['email']
                u.first_name = auth['info']['name'].split(" ").first
                u.last_name = auth['info']['name'].split(" ").last
                u.password = generated_password
                u.password_confirmation = u.password
                u.type = "Client"
                # binding.pry
                # u.image = auth['info']['image']
            end
            binding.pry	 
            session[:user_id] = @user.id
                    
            redirect_to root_path
        else #normal login
            binding.pry
            user = User.find_by(email: params[:client][:email])
            if user && user.valid_password?(params[:client][:password])
                session[:user_id] = user.id
                redirect_to root_path
            else 
                redirect_to root_path
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
      
    end

    def configure_sign_in_params
        # devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid])
        devise_parameter_sanitizer.permit(:sign_in) do |user_params|
            user_params.permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid)
        end
    end
end
