class Admins::DashboardsController < Admins::AdminController
  before_action :authorize_admin, only: :index

  def design
    @logos = Logo.by_position
  end

  def index
    @service_requests = admin_requests.page(params[:page])
    @open_service_requests = admin_requests.select(&:open?).count
    @closed_service_requests =  admin_requests.select(&:closed?).count
    @all_service_requests = admin_requests.count
    @chart_data = chart_data.to_json
    @status_data = Status.select(:name, :id).to_json
    flash.now[:notice] = I18n.t('flash.dashboards.requests_not_found') if @service_requests.empty?
    @title_page = I18n.t('.admins.dashboards.index.header')
  end

  def services
    if current_admin.is_super_admin?
      @services = Service.all
    else
      @services = current_admin.managed_services
    end
     @title_page = I18n.t('.admins.dashboards.services.managed_services')
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

  def chart_data
    return Service.chart_data if current_admin.is_super_admin?

    if current_admin.is_service_admin?
      Service.chart_data(service_admin_id: current_admin.id)
    end
  end
end
