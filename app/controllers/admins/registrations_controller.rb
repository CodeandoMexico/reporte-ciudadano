class Admins::RegistrationsController < Admins::AdminController

  def edit
    @admin = current_admin 
  end

  def update
    @admin = current_admin
    if @admin.update_attributes(params[:admin])
      redirect_to admins_categories_path, notice: I18n.t('flash.admin.updated')
    else
      render :edit
    end
  end
end
