require 'api_constraints'

Rails.application.routes.draw do

  devise_for :admins, :path_names => { :sign_in => "inicio_sesion", :sign_out => "salir", :sign_up => "registro" },  controllers: { sessions: 'admins/sessions', passwords: 'admins/passwords' }
  devise_for :users, :path_names => { :sign_in => "inicio_sesion", :sign_out => "salir", :sign_up => "registro" }, controllers: { sessions: 'users/sessions', omniauth_callbacks: "users/omniauth_callbacks", registrations: 'users/registrations' }
  devise_scope :user do
    get 'users/finish_registration', to: 'users/registrations#finish_registration'
  end

  resources :comments

  resources :quejas_y_sugerencias, as: :service_requests, controller: :service_requests  , :path_names => { :new => "nuevo"}do
    collection do
      get 'filter'
      get 'markers_for_gmap'
    end
   
    member do
      post :vote
    end

  end

  root :to => 'pages#index'

  resources :reportes_estadisticos, as: :service_survey_reports, only: [:new, :create, :show, :index], controller: :service_survey_reports

  namespace  :administradores, as: :admins, module: :admins , controller: :admin do
    resources :service_survey_reports, only: [:new, :create, :show, :index]
    resources :solicitudes_de_servicio, as: :services , controller: :services , :path_names => { :new => "nuevo", :edit => "editar" } do
      collection do
        get 'disable_service'
        get 'enable_service'
      end
      resources :messages, only: :index
    end
    resources :estatus, as: :statuses, except: [:destroy], controller: :statuses , :path_names => { :new => "nuevo", :edit => "editar" } 
    resources :registro, as: :registrations, only: [:edit, :update] , :path_names => { :new => "nuevo", :edit => "editar" } , controller: :registrations do
      get :set_password, on: :member
      put :update_password, on: :member
    end
    resources :credencial_de_autentificacion, as: :api_keys, only: [:create, :index], controller: :api_keys
    resources :quejas_o_sugerencias , as: :service_requests, controller: :service_requests, except: [:show]  do
      member do
        put 'update_status'
      end
      collection do
        get 'dashboard'
      end
    end

    resources  :encuestas_de_servicio, as: :service_surveys, controller: :service_surveys , :path_names => { :new => "nuevo", :edit => "editar" } do
      collection do
        post 'invitation_user_mail'
      end
      get :questions_text, on: :collection
      put :change_status, on: :member
      get :ignore_answers, on: :member
    end

    resources  :panel, as: :dashboards, only: [:index] ,controller: :dashboards do
      collection do
        get 'design'
        get "services" , :path => "servicios"
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

    resources :administrador_de_tramites, as: :service_admins, controller: :service_admins , :path_names => { :new => "nuevo", :edit => "editar" }

    resources :servidores_publicos, as: :public_servants, controller: :public_servants  , :path_names => { :new => "nuevo", :edit => "editar" } do
      get :disable, on: :member
      get :enable, on: :member
      get  :assign_services, :path => "asignar_tramite", on: :member
    end
  end

  get "/login" => 'sessions#new'
  get '/auth/:provider/callback' => 'sessions#create'
  delete "signout", to: 'sessions#destroy'

  resources :servicios, as: :services, only: [], controller: :services do
    collection do
      get 'load_service_fields'
    end

  end
  resources  :evalua_tramites, as: :service_surveys, only: [:index, :show] , controller: :service_surveys
  resources :encuestas, as: :answers, only: [:new, :index, :create] , :path_names => { :new => "nuevo"}, controller: :answers do

  end
  resources  :evaluaciones, as: :evaluations, only: [:index], controller: :evaluations
  resources :evaluaciones_centros_de_atencion, as: :cis_evaluations, only: [:index, :show] , controller: :cis_evaluations
  resources :service_evaluations, only: :show do
    get :export_csv, on: :member
  end

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :requests, as: :service_requests, controller: :service_requests, only: [:show, :index]
    end
  end
if Rails.env.production?  
  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
  
end
