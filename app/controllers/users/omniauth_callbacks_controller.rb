class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_filter :get_omniauth

  def authenticate_omniauth
    authentication = Authentication.find_with_omniauth(@omniauth)

    if authentication
      success_after_authentication_for(authentication.user)
    else
      user = User.find_or_build_with_omniauth(@omniauth)
      if user.save
        success_after_authentication_for(user)
      else
        session[:omniauth] = @omniauth.except('extra') # Save omniauth state
        if user.email.blank?
          redirect_to users_finish_registration_url
        else
          redirect_to new_user_registration_url
        end
      end
    end
  end

  alias_method :facebook, :authenticate_omniauth
  alias_method :twitter, :authenticate_omniauth

  private

  def get_omniauth
    @omniauth = request.env["omniauth.auth"]
  end

  def success_after_authentication_for(user)
    sign_in user
    set_flash_message(:notice, :success, :kind => @omniauth.provider.capitalize) if is_navigational_format?
    redirect_to after_sign_in_path_for(user)
  end

end
