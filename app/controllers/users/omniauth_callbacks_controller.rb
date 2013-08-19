class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    @auth = Authentication.find_for_provider_oauth(request.env["omniauth.auth"], current_user)
    user = @auth.user

    if user.persisted?
      sign_in user
      redirect_to request.env['omniauth.origin']
      set_flash_message(:notice, :success, :kind => @auth.omniauth.provider.capitalize) if is_navigational_format?
    else
      session["devise.#{@auth.omniauth.provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  alias_method :facebook, :all
  alias_method :twitter, :all
end
