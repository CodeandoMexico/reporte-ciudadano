class ServiceEvaluationsController < ApplicationController
  #before_action :authenticate_user_or_admin!
  before_action :authorize_observer
  helper_method :can_ignore_answers?
   layout 'admins'

  def show
    @service_survey_report = ServiceSurveyReport.new
    @service = Service.includes(:service_surveys, :questions, :answers).find(params[:id])
    requested_survey = @service.service_surveys.find_by_id(params[:service_survey_id])
    @service_survey = requested_survey || @service.service_surveys.last

    if @service_survey.present?
      @respondents = Kaminari.paginate_array(@service_survey.respondents).page(params[:page]).per(20)
    else
      @respondents = []
    end
  end

  def export_csv
    service_survey = ServiceSurvey.find(params[:service_survey_id])
    csv_file, csv_filename = csv_summary_answers(service_survey)
    send_data csv_file, filename: csv_filename
  end

  private

  def can_ignore_answers?(admin)
    admin && (admin.is_super_admin? || admin.is_service_admin?) && !admin.is_observer
  end

  def csv_summary_answers(service_survey)
    Evaluations.csv_summary_answers(service_survey)
  end
end