class Users::SessionsController < Devise::SessionsController

  prepend_before_filter :build_params, only: [:create]

  def after_sign_in_path_for(resource)
    return session[:my_previous_url] unless session[:my_previous_url].nil?
    root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  private

  include RegistrationsHelper

end
