Rails.application.routes.draw do
  # Public root
  root "home#index"

  # About page
  get "/about", to: "about#index"

  # Search page (category + author name)
  get "/search", to: "search#index"

  # Authentication routes
  get  "/login",  to: "sessions#new",     as: :login
  post "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  # Dashboard routes (named differently from friend's routes)
  get "/dashboard", to: "home#uindex",   as: :dashboard
  get "/admin",     to: "home#aindex",   as: :admin
  get "/my-quotes", to: "home#uquotes",  as: :my_quotes

  # Resource routes
  resources :quotes
  resources :categories
  resources :authors
  resources :users

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Catch-all for undefined routes
  match "*unmatched_path", to: "application#page_not_found", via: :all
end
