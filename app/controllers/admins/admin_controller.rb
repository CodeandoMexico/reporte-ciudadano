class Admins::AdminController < ApplicationController
  before_action :authenticate_admin_from_token!
  before_action :authenticate_admin!
  before_action :ensure_admin_is_active
  layout 'admins'

  private

  def authenticate_admin_from_token!
    admin_email = params[:admin_email].presence
    admin = admin_email && Admin.find_by_email(admin_email)
    if admin && Devise.secure_compare(admin.authentication_token, params[:admin_token])
      sign_in admin, store: true, bypass: true
    end
  end

  def ensure_admin_is_active
    unless current_admin.is_active?
      redirect_to set_password_admins_registration_path(current_admin)
    end
  end
end
