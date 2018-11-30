module ControllerHelpers
    def login_business
      login(:business)
    end
  
    def login(user)
      user = User.find(user.id)
      request.session[:user_id] = user.id
    end
  
    def current_user
      User.find(request.session[:user])
    end
end