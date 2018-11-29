Rails.application.routes.draw do  
  
  resources :users, skip: :all
  resources :clients, except: %i[index]
  resources :businesses, except: %i[index]
  resources :sessions, only: %i[new create destroy]

  root 'home#front'
  
  get "/auth/:provider/callback", to: "sessions#create"
  get "/dashboard", to: 'home#dashboard'
  
end
