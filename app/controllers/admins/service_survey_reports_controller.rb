class Admins::ServiceSurveyReportsController < ApplicationController
  layout 'admins'
  helper_method :service_cis_options
  helper_method :criterion_options
  #Metodo que se utiliza al crear reportes desde la vista de observador
  def create
    @service_survey_report = ServiceSurveyReport.new(service_survey_report_params)

    if @service_survey_report.save
      generate_services_and_cis_reports
      redirect_to  service_survey_report_path(@service_survey_report), notice: t('service_report.created')
    else
      redirect_to  admins_service_surveys_path, notice: t('service_report.no_reports')
    end
  end

  def make_report

  end

  private

  def generate_services_and_cis_reports
    ReportsWorker.perform_async(@service_survey_report.service_survey_id)
  end

  def service_survey_report_params
    params.require(:service_survey_report).permit(:service_survey_id, :service_id)
  end
  def service_cis_options
    Services.service_cis_options
  end
  
  def criterion_options
    ServiceSurveys.criterion_options
  end
end
