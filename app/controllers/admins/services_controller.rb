class Admins::ServicesController < Admins::AdminController
  helper_method :service_type_options, :service_dependency_options, :service_administrative_unit_options, :service_cis_options

  def index
    @services = Service.all
    @statuses = Status.all
  end

  def new
    @service = Service.new
    @available_admins = Admin.service_admins
  end

  def edit
    @service = Service.find(params[:id])
    @available_admins = Admin.service_admins
  end

  def create
    @service = Service.new(service_params)

    if @service.save
      redirect_to admins_services_path, notice: I18n.t('flash.service.created')
    else
      render action: "new"
    end
  end

  def update
    @service = Service.find(params[:id])

    if @service.update_attributes(service_params)
      redirect_to admins_services_path, notice: I18n.t('flash.service.updated')
    else
      render action: "edit"
    end
  end

  def destroy
    @service = Service.find(params[:id])
    @service.destroy
    redirect_to admins_services_url, notice: I18n.t('flash.service.destroyed')
  end

  def show
    @service = current_admin.managed_services.find(params[:id])
    @service_requests = @service.service_requests
  end

  private

  def service_type_options
    Services.service_type_options
  end

  def service_dependency_options
    Services.service_dependency_options
  end

  def service_administrative_unit_options
    Services.service_administrative_unit_options
  end

  def service_cis_options
    Services.service_cis_options
  end

  def service_params
    params.require(:service).permit(:name, :service_type, :dependency, :administrative_unit, :cis, :admin_id, messages: [:content, :status_id], service_fields: [:name])
  end
end
