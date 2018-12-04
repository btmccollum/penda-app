class ClientsController < ApplicationController
    before_action :signed_in?, only: %i[edit update show destroy]
    before_action :user_is_owner?, only: %i[show edit update destroy]
    
    def new
        @client = Client.new
    end

    def create
        @client = Client.create(client_params)
        if @client.valid?
            session[:user_id] = @client.id
            
            redirect_to dashboard_path, flash[:notice] = "Account successfully created!"
        else
            render :new
        end
    end

    def show

    end

    def edit
        @client = current_user
    end

    def update
        @client = current_user
        if matching_passwords?(client_params)
            if @client && @client.authenticate(client_params[:password])
                @client.update(client_params)

                redirect_to dashboard_path, flash[:notice] = "Your account has been updated."
            else 
                render :edit, flash[:alert] = "Unable to authenticate password."
            end
        else
            render :edit, flash[:alert] = "Passwords must match."
        end
    end

    def destroy
        User.destroy(current_user.id)
        reset_session

        redirect_to root_path, flash[:alert] = "Account was successfully deleted. We're sad to see you go :("
    end

    private

        def client_params
            params.require(:client).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid)
        end

        def matching_passwords?(client_params)
            client_params[:password] == client_params[:password_confirmation]
        end
end
