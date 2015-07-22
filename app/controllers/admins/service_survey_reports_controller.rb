class Admins::ServiceSurveyReportsController < ApplicationController
  layout 'admins'

  def create
    @service_survey_report = ServiceSurveyReport.new(service_survey_report_params)
    if @service_survey_report.save
      redirect_to  service_survey_report_path(@service_survey_report), notice: t('service_report.created')
    else
      redirect_to  admins_service_surveys_path, notice: t('service_report.no_reports')
    end
  end

  private

  def generate_services_and_cis_reports
    ReportsWorker.perform_async(self.service_survey_id)
  end

  def service_survey_report_params
    params.require(:service_survey_report).permit(:service_survey_id)
  end
end
