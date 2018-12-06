class BusinessesController < ApplicationController
    before_action :signed_in?, only: %i[edit update destroy]
    before_action :user_is_owner?, only: %i[edit update destroy]
    layout "welcome_screen", only: %i[new create]

    def new
        @business = Business.new
    end

    def create
        @business = Business.new(business_params)
        if @business.save
            session[:user_id] = @business.id
            
            flash[:notice] = "Account successfully created!"
            redirect_to dashboard_path
        else
            render :new
        end
    end

    def edit
        @business = current_user
    end

    def update
        @business = current_user
        @business.update(business_params)
        if @business.valid?
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

        def business_params
            params.require(:business).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid)
        end
end
