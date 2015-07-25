class SessionsController < ApplicationController

  def new
  end

  def create
    auth = Services::Omniauth.new(request.env["omniauth.auth"])
    if auth.authenticated?
      sign_in_and_redirect(auth.user.id, request.env['omniauth.origin'])
    else
      redirect_to root_path, flash: { notice: 'Ha ocurrido un problema con tu acceso.' }
    end
  end

  def after_sign_in_path_for(resource)
    return evaluations_path if current_user.is_observer?
    root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, flash: { notice: 'Has salido exitosamente del sistema' }
  end
end
