class Admins::RegistrationsController < Admins::AdminController

  def edit
    @admin = current_admin 
  end

  def update
    @admin = current_admin
    if @admin.update_attributes(admin_params)
      redirect_to admins_services_path, notice: I18n.t('flash.admin.updated')
    else
      render :edit
    end
  end

  private

  def admin_params
    params.require(:admin).permit(:name, :avatar, :email)
  end
end
