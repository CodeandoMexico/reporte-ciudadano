ReporteCiudadano::Application.routes.draw do

  devise_for :admins, controllers: { sessions: 'admins/sessions' }

  resources :reports
  root :to => 'reports#index'

  namespace :admins do
    resources :categories
  end
  
  get "/login" => 'sessions#new'
  get '/auth/:provider/callback' => 'sessions#create'
  delete "signout", to: 'sessions#destroy'

  resources :categories, only: [] do
    collection do
      get 'load_category_fields'
    end
  end

end
