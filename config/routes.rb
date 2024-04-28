Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "products#index"

  # Add and remove products from the session cart.
  post 'products/add_to_cart/:id', to: 'products#add_to_cart', as: 'add_to_cart'
  post 'products/change_quantity/:id', to: 'products#change_quantity', as: 'change_quantity'
  delete 'products/remove_from_cart/:id', to: 'products#remove_from_cart', as: 'remove_from_cart'

  get "/cart", to: "static_pages#cart"

  resources :products, only: ['index', 'show'] do
    collection do
      get 'search'
    end
  end

  resources :categories, only: ['show']
end
