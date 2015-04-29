class Admins::RegistrationsController < Admins::AdminController
  skip_before_action :ensure_admin_is_active, only: [:set_password, :update]

  def edit
    @admin = current_admin
  end

  def update
    @admin = current_admin
    if @admin.update_attributes(admin_params)
      sign_in current_admin, bypass: true
      redirect_to edit_admins_registration_path(current_admin), notice: I18n.t('flash.admin.updated')
    else
      render :edit
    end
  end

  def set_password
    @admin = current_admin
  end

  private

  def admin_params
    params.require(:admin).permit(:name, :avatar, :email, :password, :password_confirmation, :active)
  end
end
