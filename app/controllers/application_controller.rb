class ApplicationController < ActionController::Base

  before_action :drop_headers

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include SessionsHelper

  private

  # Don't allow use of X-Forwarded-Host to prevent
  # Host Header attack
  # http://www.acunetix.com/blog/articles/automated-detection-of-host-header-attacks/
  def drop_headers
    if request.env['HTTP_X_FORWARDED_HOST']
      request.env.except!('HTTP_X_FORWARDED_HOST')
    end
  end

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
