ReporteCiudadano::Application.routes.draw do

  devise_for :admins
  resources :reports

  root :to => 'reports#index'

end
