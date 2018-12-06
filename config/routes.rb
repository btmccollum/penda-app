Rails.application.routes.draw do  
  
  resources :users, skip: :all
  resources :clients, except: %i[index show]
  resources :businesses, except: %i[index show]
  resources :sessions, only: %i[new create destroy]
  resources :comments, only: %i[create destroy]
  resources :projects, shallow: true do
    resources :clients, only: %i[new create]
    resources :time_entries, only: %i[index show new create]
    resources :comments, only: %i[index]
  end

  root 'home#front'
  
  get "/auth/:provider/callback", to: "sessions#create"
  get "/dashboard", to: "home#dashboard"
  get "/choice", to: "home#choice"
  get "/failure", to: "sessions#failure"
  get "/login", to: "sessions#new"
  
end
