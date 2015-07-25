class Users::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    return evaluations_path if current_user.is_observer?
    root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
