class Admins::DashboardsController < Admins::AdminController

  def design
    @logos = Logo.by_position
  end

  def index
    @service_requests = ServiceRequest.filter_by_search(params).page(params[:page])
    @open_service_requests = ServiceRequest.not_closed.count
    @closed_service_requests = ServiceRequest.closed.count
    @all_service_requests = ServiceRequest.count
    @chart_data = Service.chart_data.to_json
    @status_data = Status.select(:name, :id).to_json
    flash.now[:notice] = I18n.t('flash.dashboards.requests_not_found') if @service_requests.empty?
  end

  def services
    if current_admin.is_super_admin?
      @services = Service.all
    else
      @services = current_admin.managed_services
    end
  end
end
