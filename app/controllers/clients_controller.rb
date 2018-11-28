class ClientsController < ApplicationController
    before_action :signed_in?, only: %i[edit update show destroy]
    
    def new
        @client = Client.new
    end

    def create
        @client = Client.create(client_params)
        session[:user_id] = @client.id
        redirect_to root_path
    end

    def show

    end

    def edit
        if user_is_owner?
            @client = current_user
        else
            flash[:alert] = "Unauthorized Access."
            redirect_to root_path
        end
    end

    def update
        @client = current_user
        @client.update(client_params)
        flash[:notice] = "Your account has been updated."
        redirect_to root_path
    end

    def destroy
    end

    private

    def client_params
        params.require(:client).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid)
    end
end
