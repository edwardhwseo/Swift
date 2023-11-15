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

  scope '/checkout' do
    post 'create', to: 'checkout#create', as: 'checkout_create'
    get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
    get 'success', to: 'checkout#success', as: 'checkout_success'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
