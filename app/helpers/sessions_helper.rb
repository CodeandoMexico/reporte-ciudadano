module SessionsHelper

  def current_user
    @curret_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    current_user.present?  
  end

  def sign_in_and_redirect(user_id, path=nil)
    session[:user_id] = user_id
    redirect_to_back_or path
    clear_location
  end

  def failure
    redirect_to root_path, notice: "No pudimos terminar el proceso, intenta de nuevo."
  end

  def authenticate_user!
    deny_access unless user_signed_in?
  end

  def deny_access
    store_location
    redirect_to login_path
  end

  def store_location
    session[:return_to] = request.fullpath 
  end
  
  def redirect_to_back_or path = root_path
    redirect_to session[:return_to] || path
  end

  def clear_location
    session[:return_to] = nil 
  end
end
