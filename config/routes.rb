Rails.application.routes.draw do  
  
  resources :users, skip: :all
  resources :clients, except: %i[index show]
  resources :businesses, except: %i[index show]
  resources :sessions, only: %i[new create destroy]
  resources :comments, only: %i[create destroy]
  resources :projects, except: %i[index edit] do
    resources :clients, only: %i[new create], shallow: true
    resources :time_entries
    resources :comments, only: %i[index], shallow: true
  end

  root 'home#front'
  
  get "/most-recently-active", to: "home#activity"
  get "/auth/:provider/callback", to: "sessions#create"
  get "/dashboard", to: "home#dashboard"
  get "/choice", to: "home#choice"
  get "/failure", to: "sessions#failure"
  get "/login", to: "sessions#new"
  
end
