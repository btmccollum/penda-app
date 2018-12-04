class BusinessesController < ApplicationController
    before_action :signed_in?, only: %i[edit update show destroy]
    before_action :user_is_owner?, only: %i[show edit update destroy]

    def new
        @business = Business.new
    end

    def create
        @business = Business.create(business_params)
        if @business.valid?
            session[:user_id] = @business.id
            
            redirect_to dashboard_path, flash[:notice] = "Account successfully created!"
        else
            render :new
        end
    end

    def show
      
    end

    def edit
        @business = current_user
    end

    def update
        @business = current_user
        if matching_passwords?(business_params)
            if @business && @business.authenticate(business_params[:password])
                @business.update(business_params)

                redirect_to dashboard_path, flash[:notice] = "Your account has been updated."
            else 
                render :edit, flash[:alert] = "Unable to authenticate password."
            end
        else
            flash[:alert] = "Passwords must match."
            render :edit
        end
    end

    def destroy
        User.destroy(current_user.id)
        reset_session

        redirect_to root_path, flash[:alert] = "Account was successfully deleted. We're sad to see you go :("
    end

    private

        def business_params
            params.require(:business).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid)
        end

        def matching_passwords?(business_params)
            business_params[:password] == business_params[:password_confirmation]
        end
end
