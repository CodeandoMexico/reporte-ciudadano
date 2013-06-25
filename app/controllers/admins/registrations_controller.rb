class Admins::RegistrationsController < Admins::AdminController

  def edit
    @admin = current_admin 
  end

  def update
    @admin = current_admin
    if @admin.update_attributes(params[:admin])
      redirect_to admins_categories_path, notice: 'El perfil fue editado satisfactoriamente'
    else
      render :edit
    end
  end
end
