ReporteCiudadano::Application.routes.draw do

  devise_for :admins
  resources :reports

  root :to => 'reports#index'

  namespace :admin do
    resources :categories
  end
end
