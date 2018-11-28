class SessionsController < Devise::SessionsController
    before_action :configure_permitted_parameters, if: :devise_controller?
    skip_before_action :verify_signed_out_user

    # def new
    # end

    def create
        if auth #omniauth login
            session.clear
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
            session[:user_id] = @user.id
                    
            redirect_to root_path
        else #normal login
            session.clear
            user = User.find_by(email: resource_params[:email])
            if user && user.valid_password?(params[:client][:password])
                session[:user_id] = user.id
                redirect_to root_path
            else 
                redirect_to root_path, alert: "Invalid credentials."
            end
        end
    end

    def destroy
        session.clear
        binding.pry
    
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
        devise_parameter_sanitizer.permit(:sign_in) do |resource_params|
            resource_params.permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid)
        end
    end
        # def resource_params
        #     params.require(:client).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid)
        # end

        # def sign_in_params
        #     params.permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid)
        # end
    # end
end
