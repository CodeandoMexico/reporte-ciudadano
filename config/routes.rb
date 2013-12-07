require 'api_constraints'
ReporteCiudadano::Application.routes.draw do

  devise_for :admins, controllers: { sessions: 'admins/sessions' }
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :comments

  resources :requests, as: :service_requests, controller: :service_requests do
    collection do
      get 'filter'
    end
    member do
      post :vote
    end
  end

  root :to => 'pages#index'

  namespace :admins do
    resources :services do
      resources :messages, only: :index
    end
    resources :statuses, except: [:destroy]
    resources :registrations, only: [:edit, :update]
    resources :api_keys, only: [:create, :index]
    resources :requests, as: :service_requests, controller: :service_requests, except: [:show]  do
      member do
        put 'update_status'
      end
      collection do
        get 'dashboard'
      end
    end
    resources :dashboards, only: [:index] do
      collection do
        get 'design'
      end
    end

    resources :logos, except: :index do
      collection do
        post 'rearrange'
      end
    end

    resources :application_settings do
      collection do
        put :css_theme
      end
    end
  end

  get "/login" => 'sessions#new'
  get '/auth/:provider/callback' => 'sessions#create'
  delete "signout", to: 'sessions#destroy'

  resources :services, only: [] do
    collection do
      get 'load_service_fields'
    end
  end

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :requests, as: :service_requests, controller: :service_requests, only: [:show, :index]
    end
  end

end
