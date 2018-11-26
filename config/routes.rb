Rails.application.routes.draw do
  get 'welcome/home'
  
  # devise_for :users
  devise_for :clients
  devise_for :business

  root 'welcome#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
