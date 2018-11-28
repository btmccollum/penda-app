Rails.application.routes.draw do  
  resources :users, skip: :all
  resources :clients, except: %i[index]
  resources :businesses, except: %i[index]
  resources :sessions, only: %i[new create destroy]

 
  get "/auth/:provider/callback" => "sessions#create"


  root 'welcome#home'

end
