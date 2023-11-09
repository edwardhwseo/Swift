Rails.application.routes.draw do
  # get 'home/index'
  # get 'categories/index'
  # get 'categories/show'
  root to: 'home#index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :pages
  get '/products/search', to: 'products#search', as: 'products_search'
  resources :products
  resources :categories
  resources :carts, only: %i[index create destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
