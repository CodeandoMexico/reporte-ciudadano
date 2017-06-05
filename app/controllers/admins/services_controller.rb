class Admins::ServicesController < Admins::AdminController
  before_action :authorize_admin, only: :show
  before_action :set_title
  before_action :set_search, only: :index


  helper_method :service_type_options,
                :organisation_options,
                :service_dependency_options,
                :agency_options,
                :service_administrative_unit_options,
                :service_cis_options,
                :is_assigned_to_cis?,
                :service_name_options

  before_action :set_admin

  def index
    params[:q] ||= {}

    respond_to do |format|
      format.html do
        @services = Service.all
        search_services
        @statuses = Status.unscoped.all
      end

      format.json do
        @q = Service.ransack(params[:q])
        @services = @q.result
        render json: @services, root: false
      end
    end
  end

  def new
    @service = Service.new
  end

  def edit
    @service = Service.find(params[:id])
  end

  def create
    time = Time.new
    @service = Service.new(service_params)
    if @service.save
      @service.homoclave = Services.generate_homoclave_for(@service)
      @service.save
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

  def import
    ServicesUploader.import_services_from(params[:file])
    redirect_to admins_services_path, notice: I18n.t('flash.service.services_bulk')
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

  def organisation_options
    if current_admin.is_super_admin?
      Organisation.pluck(:name, :id)
    else
      [
        [current_admin.organisation.name, current_admin.organisation.id]
      ]
    end
  end

  def service_administrative_unit_options
    Services.service_administrative_unit_options
  end

  def agency_options
    Agency.pluck(:name, :id)
  end

  def service_cis_options
    Services.service_cis_options
  end

  def service_name_options
    Services.service_name_options
  end

  def search_services
    if params[:q].present?
      @services = @services.where(name:  params[:q][:name]) unless params[:q][:name].blank?
      @services = @services.where(dependency: params[:q][:dependency] ) unless params[:q][:dependency].blank?

      @services = @services.where(organisation_id: params[:q][:organisation_id]) unless params[:q][:organisation_id].blank?
      @services = @services.where(agency_id: params[:q][:agency_id] ) unless params[:q][:agency_id].blank?

      @services = @services.where(administrative_unit: params[:q][:administrative_unit] ) unless params[:q][:administrative_unit].blank?
      @services = @services.where("cis ILIKE ANY ( array[?] )", "%#{params[:q][:cis]}%") unless params[:q][:cis].blank?
    end
  end

  def set_admin
    @available_admins = Admin.service_admins
  end

  def service_params
    params.require(:service).permit(
      :status,
      :name,
      :service_type,
      :dependency,
      :organisation_id,
      :administrative_unit,
      :agency_id,
      :service_admin_id,
      messages: [:content, :status_id], service_fields: [:name], cis: []
    ).tap do |attributes|
      if attributes["service_admin_id"].blank?
        attributes["service_admin_id"] = nil
      end

      if attributes["cis"].reject(&:empty?).empty?
        attributes["cis"] = nil
      end
    end
  end
end
