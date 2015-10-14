class Admins::RegistrationsController < Admins::AdminController
  skip_before_action :ensure_admin_is_active, only: [:set_password, :update]
  append_before_action :build_params

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

  def update_password
    @admin = current_admin
    if @admin.update_with_password(admin_with_password_params)
      sign_in current_admin, bypass: true
      redirect_to edit_admins_registration_path(current_admin), notice: I18n.t('flash.admin.password_updated')
    else
      render :edit
    end
  end

  private

  def admin_params
    if params[:admin][:password_confirmation].present?
      params[:admin].merge!(authentication_token: token_generator.generate_token)
    end
    params.require(:admin).permit(:name, :avatar, :email, :password, :password_confirmation, :active, :authentication_token)
  end

  def admin_with_password_params
    params.require(:admin).permit(:password, :password_confirmation, :current_password)
  end

  def token_generator
    UniqueTokenGenerator.new(Admin, :authentication_token)
  end

  include RegistrationsHelper

end
