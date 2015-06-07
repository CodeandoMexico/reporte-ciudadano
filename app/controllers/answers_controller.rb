class AnswersController < ApplicationController
  def new
    service_survey = ServiceSurvey.find(params[:service_survey_id])
    @service_survey = ServiceSurveys.form_for_answers(service_survey)
  end

  def create
    raise params.inspect
  end
end
