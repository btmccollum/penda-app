class ClientsController < ApplicationController
    before_action :signed_in?, only: %i[edit update destroy]
    before_action :already_signed_in?, only: %i[new create]
    before_action :is_owner?, only: %i[edit update destroy]
    layout "welcome_screen", only: %i[new create]
    
    def new
        @client = Client.new
    end

    def create
        @client = Client.new(client_params)
        if @client.save
            session[:user_id] = @client.id
            
            flash[:notice] = "Account successfully created!"
            redirect_to dashboard_path
        else
            render :new
        end
    end

    def edit
        @client = current_user
    end

    def update
        @client = current_user
        @client.update(client_params)
        if @client.valid?
            flash[:notice] = "Your account has been updated."
            redirect_to dashboard_path
        else
            render :edit
        end
    end

    def destroy
        User.destroy(current_user.id)
        reset_session

        flash[:alert] = "Account was successfully deleted. We're sad to see you go :("
        redirect_to root_path
    end

    private

        def client_params
            params.require(:client).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid)
        end
end
