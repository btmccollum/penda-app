class BusinessesController < ApplicationController
    before_action :signed_in?, only: %i[edit update show destroy]

    def new
        @business = Business.new
    end

    def create
        business = Business.create(biz_params)
        session[:user_id] = business.id
        redirect_to root_path
    end

    def show
      
    end

    def edit
        if user_is_owner?
            @business = current_user
        else
            flash[:alert] = "Unauthorized Access."
            redirect_to root_path
        end
    end

    def update
        @business = current_user
        @business.update(business_params)
        flash[:notice] = "Your account has been updated."
        redirect_to root_path
    end

    def destroy
    end

    private

    def biz_params
        params.require(:business).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid)
    end
end
