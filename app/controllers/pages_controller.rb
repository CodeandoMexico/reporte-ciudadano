class PagesController < ApplicationController
  def index
    @service_requests = ServiceRequest.filter_by_search(params).page(params[:page])
    @open_service_requests = ServiceRequest.not_closed.count
    @closed_service_requests = ServiceRequest.closed.count
    @all_service_requests = ServiceRequest.count
    @chart_data = Service.chart_data.to_json
    @status_data = Status.select(:name, :id).to_json
    flash.now[:notice] = "No se encontraron solicitudes de servicio." if @service_requests.empty?
    @services_count = Service.count
    @active_citizen_count = SurveyAnswer.select(:user_id).uniq.count
    @public_servant_assessed_count = 0
    @url_video = 'https://www.youtube.com/watch?v=uFLWkxsUFr8'
  end
end
