class Admins::ServiceSurveysController < ApplicationController
  layout 'admins'
  helper_method :phase_options

  def index
    @service_surveys = ServiceSurvey.all
  end

  def new
    @service_survey = ServiceSurvey.new
    @available_services = current_admin.managed_services
  end

  def create
    @service_survey = current_admin.service_surveys.new(service_survey_params)
    if @service_survey.save
      redirect_to admins_service_surveys_path, notice: t('flash.service_survey.created')
    else
      render :new
    end
  end

  private

  def service_survey_params
    params.require(:service_survey).permit(:title, :phase, service_ids: [])
  end

  def phase_options
    ServiceSurveys.phase_options
  end
end
