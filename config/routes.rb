require 'api_constraints'

Rails.application.routes.draw do

  devise_for :admins, controllers: { sessions: 'admins/sessions', passwords: 'admins/passwords' }
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: 'users/registrations' }
  devise_scope :user do
    get 'users/finish_registration', to: 'users/registrations#finish_registration'
  end

  resources :comments

  resources :requests, as: :service_requests, controller: :service_requests do
    collection do
      get 'filter'
      get 'markers_for_gmap'
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
    resources :registrations, only: [:edit, :update] do
      get :set_password, on: :member
      put :update_password, on: :member
    end
    resources :api_keys, only: [:create, :index]
    resources :requests, as: :service_requests, controller: :service_requests, except: [:show]  do
      member do
        put 'update_status'
      end
      collection do
        get 'dashboard'
      end
    end

    resources :service_surveys do
      get :questions_text, on: :collection
      put :change_status, on: :member
    end
    resources :dashboards, only: [:index] do
      collection do
        get 'design'
        get 'services'
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
        put :map_constraints
      end
    end

    resources :service_admins
    resources :public_servants do
      get :disable, on: :member
      get :enable, on: :member
      get :assign_services, on: :member
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

  resources :service_surveys, only: [:index, :show]
  resources :answers, only: [ :new, :index, :create ]

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :requests, as: :service_requests, controller: :service_requests, only: [:show, :index]
    end
  end

end
