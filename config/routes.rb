Rails.application.routes.draw do  
  # devise_for :users
  devise_for :users, skip: :all
  devise_for :clients, controllers: { registrations: 'clients/registrations', sessions: 'sessions'}
  devise_for :business, controllers: { registrations: 'business/registrations', sessions: 'sessions'}

  devise_scope :client do
    get "/auth/:provider/callback" => "sessions#create"
  end

  # devise_scope :clients do
  #   # get "/users/auth/facebook/callback" => "users/omniauth_callbacks#facebook"
  #   get "/auth/:provider/callback" => "sessions#create"
  # end


  root 'welcome#home'

  # get "/auth/:action/callback", :controller => "authentications", :constraints => { :action => /twitter|google/ }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
