class ServiceEvaluationsController < ApplicationController
  def show
    @service = Service.find(params[:id])
    @service_report = Reports.current_service_report_for(@service, ServiceReport)
  end
end
