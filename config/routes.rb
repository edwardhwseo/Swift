Rails.application.routes.draw do
  # get 'home/index'
  # get 'categories/index'
  # get 'categories/show'
  root to: 'home#index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :pages
  resources :products
  resources :categories
  resources :carts, only: %i[create destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
