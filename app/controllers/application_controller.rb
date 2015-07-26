class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include SessionsHelper

  private

  def authenticate_user_or_admin!
    unless signed_in?
      authenticate_user!
    end
  end

  def authorize_observer
    unless (current_user && current_user.is_observer?) || current_admin
      redirect_to root_path
    end
  end
end
