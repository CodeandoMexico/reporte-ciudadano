class Admins::ServicesController < Admins::AdminController
  before_action :authorize_admin, only: :show
  before_action :set_title
  helper_method :service_type_options, :service_dependency_options, :service_administrative_unit_options, :service_cis_options, :is_assigned_to_cis?,:service_name_options
  before_action :set_search

  def index
    load_services
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
    time = Time.new
    @service = Service.new(service_params)
    @service.homoclave = Services.generate_homoclave_for(@service)
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
    @service = Service.find(params[:id])
    @service_requests = @service.service_requests
  end

  def set_search
    @search = Service.search(params[:q])
  end

    def disable_service
    @service = Service.find(params[:id])
    if @service.update_attributes(status: "inactivo")
      redirect_to admins_services_path, notice: t('flash.service.disabled')
    else
      redirect_to admins_services_path, notice: t('flash.service.could_not_be_disabled')
    end
  end

  def enable_service
    @service = Service.find(params[:id])
    if @service.update_attributes(status: "activo")
      redirect_to admins_services_path, notice: t('flash.service.enabled')
    else
      redirect_to admins_services_path, notice: t('flash.service.could_not_be_enabled')
    end
  end

  private

  def set_title
    @title_page = I18n.t('admins.services.index.header')
  end

  def is_assigned_to_cis?(service, cis)
    Services.is_assigned_to_cis?(service, cis[:id])
  end

  def authorize_admin
    permissions = Admins.permissions_for_admin(current_admin)
    unless permissions.can_manage_service_requests?(current_service)
      redirect_to admins_dashboards_path
    end
  end

  def current_service
    @service ||= Service.find(params[:id])
  end

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
  
  def service_name_options
    Services.service_name_options
  end

  def load_services
      unless params[:q].nil? 
            unless params[:q][:dependency].empty?
              dependency_param = params[:q][:dependency]
            end
            unless params[:q][:administrative_unit].empty?
              administrative_unit_param = params[:q][:administrative_unit]
            end
            unless params[:q][:cis].empty?
              cis_param = params[:q][:cis]
            end
            unless params[:q][:name].empty?
              name_param = params[:q][:name]
            end
      end

        @services = Service.all
        unless params[:q].nil? 
          @services =  @services.where(name:  name_param ) unless name_param.nil?
          @services =  @services.where(dependency: dependency_param ) unless dependency_param.nil?
          @services =   @services.where(administrative_unit: administrative_unit_param ) unless administrative_unit_param.nil?
          @services =  @services.where("cis ILIKE ANY ( array[?] )", "%#{cis_param}%") unless cis_param.nil?
        end

  end

  def service_params
    params.require(:service).permit(:status, :name, :service_type, :dependency, :administrative_unit, :service_admin_id, messages: [:content, :status_id], service_fields: [:name], cis: [])
  end
end
