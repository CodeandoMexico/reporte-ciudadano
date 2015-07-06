class ServiceSurveyReportsController < ApplicationController

  before_action :set_reports_for_index, :only => :index

  def index
    @service_surveys_reports = set_reports_for_index
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
    params.permit(:service_survey_id, :service_survey_report, :page)
  end

  def set_reports_for_index
    if service_survey_report_params.has_key?(:service_survey_id)
      @service_surveys = ServiceSurveyReport
                         .where(service_survey_id: service_survey_report_params[:service_survey_id])
                         .order(created_at: :desc)
                         .page(service_survey_report_params[:page]).per(25)
    else
      @service_surveys = ServiceSurveyReport.all.order(created_at: :desc).page(params[:page]).per(25)
    end
  end
end