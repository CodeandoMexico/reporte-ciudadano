ReporteCiudadano::Application.routes.draw do

  devise_for :admins
  resources :reports
  root :to => 'reports#index'

  namespace :admin do
    resources :categories
  end
  

  get "login" => 'sessions#new'
  get '/auth/:provider/callback' => 'sessions#create'
  delete "signout", to: 'sessions#destroy'

end
