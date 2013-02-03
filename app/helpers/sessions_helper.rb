module SessionsHelper

  def current_user
    @curret_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    current_user.present?  
  end

  def sign_in_and_redirect(user_id)
    session[:user_id] = user_id
    redirect_to root_path
  end

  def failure
    redirect_to root_path, notice: "No pudimos terminar el proceso, intenta de nuevo."
  end

  def authenticate_user!
    deny_access unless user_signed_in?
  end

  def deny_access
    redirect_to root_path
  end
end
