class ServiceSurveyReportsController < ApplicationController

  def index
    @service_surveys_report = ServiceSurveyReport.all
    @surveys = ServiceSurvey.all
  end

  def new
    @service_surveys_report = ServiceSurveyReport.new
  end

  def create
    @service_surveys_report = ServiceSurveyReport.new(service_survey_report_params)
  end

  def show
    @service_surveys_report = ServiceSurveyReport.find(params[:id])
  end

  private

  def service_survey_report_params
    params.require(:service_survey_report).permit( :service_survey_id)
  end
end