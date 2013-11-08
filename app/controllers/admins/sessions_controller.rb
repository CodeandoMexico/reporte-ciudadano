class Admins::SessionsController < Devise::SessionsController
  layout 'admins'

  def after_sign_in_path_for(resource)
    admins_services_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
