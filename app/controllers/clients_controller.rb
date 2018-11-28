class ClientsController < ApplicationController
    before_action :signed_in?, only: %i[edit update show destroy]
    
    def new
        @client = Client.new
    end

    def create
        @client = Client.create(client_params)
        session[:user_id] = @client.id
        render 'welcome/home'
    end

    def show
    end

    def edit
        @client = current_user
    end

    def update
        @client = current_user
        @client.update(client_params)
        render 'welcome/home'
    end

    def destroy
    end

    private

    def client_params
        params.require(:client).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid)
    end
end
