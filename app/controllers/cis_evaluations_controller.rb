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
  end

  private

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
