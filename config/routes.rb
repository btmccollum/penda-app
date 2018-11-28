Rails.application.routes.draw do  
  resources :users, skip: :all
  resources :clients, except: %i[index]
  resources :business, except: %i[index]
  resources :sessions, only: %i[new create destroy]

 
  get "/auth/:provider/callback" => "sessions#create"


  root 'welcome#home'

  # get "/auth/:action/callback", :controller => "authentications", :constraints => { :action => /twitter|google/ }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
