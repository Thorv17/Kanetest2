# CSI2441 Assignment 2 - ThoughtVault
# Student: Vinith Magheswaran (ID: 10676287)
# Route definitions for the ThoughtVault Rails application

Rails.application.routes.draw do
  # Public landing page showing 10 most recent public quotes
  root "home#index"

  # Public information about the application
  get "/about", to: "about#index"

  # Public search for quotes by category name or author name (no authentication required)
  get "/search", to: "search#index"

  # Authentication routes for login/logout
  get  "/login",  to: "sessions#new",     as: :login
  post "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  # Dashboard routes for authenticated users
  # /dashboard: standard user dashboard showing their own quotes
  # /admin: admin dashboard with system overview
  # /my-quotes: alias for user's quote collection
  get "/dashboard", to: "home#uindex",   as: :dashboard
  get "/admin",     to: "home#aindex",   as: :admin
  get "/my-quotes", to: "home#uquotes",  as: :my_quotes

  # RESTful resource routes for CRUD operations
  resources :quotes
  resources :categories
  resources :authors
  resources :users

  # Rails health check endpoint for uptime monitoring
  get "up" => "rails/health#show", as: :rails_health_check

  # Catch-all route for undefined URLs; renders 404 page
  match "*unmatched_path", to: "application#page_not_found", via: :all
end
