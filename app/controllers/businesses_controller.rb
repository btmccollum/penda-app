class BusinessesController < ApplicationController
    before_action :signed_in?, only: %i[edit update show destroy]

    def new
        @business = Business.new
    end

    def create
        business = Business.create(biz_params)
        session[:user_id] = business.id
        render 'welcome/home'
    end

    def show
        binding.pry
    end

    def edit
        @business = current_user
    end

    def update
    end

    def destroy
    end

    private

    def biz_params
        params.require(:business).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :type, :provider, :uid)
    end
end
