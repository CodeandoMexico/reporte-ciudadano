class CisEvaluationsController < ApplicationController
  layout 'observers'
  helper_method :criterions
  before_action :authorize_observer

  def index
    @cis = Evaluations.cis_with_results(available_cis, Service.all)
  end

  def show
    @cis = Evaluations.cis_evaluation_for(cis, Service.all)
    @cis_report = Reports.current_cis_report_for(
      cis,
      cis_report_store: CisReport,
      survey_reports: @cis.service_surveys_reports,
      translator: I18n.method(:t))
    @services = sorted_services(@cis.services)
    @next_possible_direction = toggle_sort_direction
    @sorted_by = params[:sort_by]
  end

  private

  def sorted_services(services)
    return services unless params[:sort_by].present?
    sorted = services.sort_by do |service|
      service.overall_evaluation_for(params[:sort_by].to_sym)
    end

    if params[:direction] == 'asc'
      sorted
    else
      sorted.reverse
    end
  end

  def toggle_sort_direction
    return :desc if params[:direction] == "asc"
    :asc
  end

  def criterions
    ServiceSurveys.criterion_options_available
  end

  def authorize_observer
    unless current_user.is_observer?
      redirect_to root_path
    end
  end

  def available_cis
    Services.service_cis
  end

  def cis
    available_cis.select { |cis| cis[:id].to_s ==  params[:id] }.first
  end
end
