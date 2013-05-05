require 'api_constraints'
ReporteCiudadano::Application.routes.draw do

  devise_for :admins, controllers: { sessions: 'admins/sessions' }

  resources :comments

  resources :reports do
    collection do
      get 'filter'
    end
    member do
      post :vote
    end
  end

  root :to => 'reports#index'

  namespace :admins do
    resources :categories
    resources :api_keys, only: [:create]
    resources :reports, only: [:edit, :update] do 
      member do
        put 'update_status'
      end
    end
  end
  
  get "/login" => 'sessions#new'
  get '/auth/:provider/callback' => 'sessions#create'
  delete "signout", to: 'sessions#destroy'

  resources :categories, only: [] do
    collection do
      get 'load_category_fields'
    end
  end

  namespace :api, defaults: { format: 'json' } do
    devise_for :admins
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :reports, only: [:create] do
        put 'update_status'
      end
    end
  end

end
