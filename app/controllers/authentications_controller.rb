class AuthenticationsController < ApplicationController

  def create
    auth = Services::Omniauth.new(request.env["omniauth.auth"]) 
    if auth.authenticated?
      sign_in_and_redirect(auth.user.id)
    else
      redirect_to root_path
    end
  end

end
