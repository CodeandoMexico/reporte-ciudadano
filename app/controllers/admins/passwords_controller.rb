class Admins::PasswordsController < Devise::PasswordsController
  layout "admins"

  protected

  def after_sending_reset_password_instructions_path_for(resource_name)
    new_admin_session_path
  end

  def after_resetting_password_path_for(resource)
    admins_dashboards_path
  end
end