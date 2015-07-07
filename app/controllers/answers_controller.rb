class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new]

  def new
    service_survey = ServiceSurvey.find(params[:service_survey_id])
    @service_survey = ServiceSurveys.form_for_answers(service_survey)
  end

  def create
    answers = ServiceSurveys.generate_answer_records(answers_params, current_user.id)
    answers.each do |answer|
      answer = SurveyAnswer.new(answer)
      answer.save
    end
    service_survey = ServiceSurvey.find(params[:service_survey_id])
    UserMailer.confirm_service_survey_answer(service_survey, current_user).deliver
    redirect_to service_survey_report_path(:service_survey_id => service_survey.id), notice: t('.answers_created_successfully')
  end

  private

  def answers_params
    params.require(:answers).values
  end
end
