class Admins::SessionsController < Devise::SessionsController
  layout 'admins'
  append_before_action :build_params, only: [:create]


  def after_sign_in_path_for(resource)
    return admins_service_requests_path if current_admin.is_public_servant?
    admins_dashboards_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  private
  include RegistrationsHelper

end
