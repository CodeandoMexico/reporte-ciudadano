class Admins::DashboardsController < Admins::AdminController
  before_action :authorize_admin, only: :index
  before_action :set_search
  helper_method :dependency_options, :administrative_unit_options, :cis_options

  def design
    @logos = Logo.by_position
  end

  def index
    @service_requests = admin_requests.page(params[:page])
    @open_service_requests = admin_requests.where(status_id: 1).count#select(&:open?).count
    @closed_service_requests =  admin_requests.where(status_id: 2).count#.select(&:closed?).count
    @all_service_requests = admin_requests.count
    @chart_data = chart_data.to_json
    @dependencies_chart_data = DependenciesChart.data(dependency_options).to_json
    @status_data = Status.select(:name, :id).to_json
    flash.now[:notice] = I18n.t('flash.dashboards.requests_not_found') if @service_requests.empty?
    @title_page = I18n.t('.admins.dashboards.index.header')
  end

  def services
    @services = Admins.services_for(current_admin).active
    search_service
    @title_page = I18n.t('.admins.dashboards.services.managed_services')
    @search_service = Service.active
  end

  def export
    csv_file, csv_filename = ServiceRequests.general_report_csv.to_csv
    send_data csv_file, filename: csv_filename
  end

  private

  def authorize_admin
    if current_admin.is_public_servant?
      redirect_to admins_service_requests_path
    end
  end

  def admin_requests
    @requests ||= Admins.service_requests_for(current_admin, params)
  end

  def set_search
    @search = Service.search(params[:q])
  end

  def dependency_options
    Services.service_dependency_options
  end

  def administrative_unit_options
    Services.service_administrative_unit_options
  end

  def cis_options
    Services.service_cis_options
  end

  def chart_data
    return Service.chart_data if current_admin.is_super_admin?

    if current_admin.is_service_admin?
      Service.chart_data(service_admin_id: current_admin.id)
    end
  end

  def search_service
    if params[:q].present?
      @services =  @services.where(dependency: params[:q][:dependency] ) unless params[:q][:dependency].blank?
      @services =   @services.where(administrative_unit: params[:q][:administrative_unit] ) unless params[:q][:administrative_unit].blank?
      @services =  @services.where("cis ILIKE ANY ( array[?] )", "%#{params[:q][:cis]}%") unless params[:q][:cis].blank?
    end
  end
end
