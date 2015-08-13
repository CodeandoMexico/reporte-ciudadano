class AnswersController < ApplicationController
  before_action :save_path
  after_action :delete_path
  before_action :authenticate_user!, only: [:create, :new]
  before_action :authorize_user_to_answer, only: [:create, :new]

  def new
    service_survey = ServiceSurvey.find(params[:service_survey_id])
    @service_survey = ServiceSurveys.form_for_answers(service_survey)
    @cis_id = params[:cis_id]
  end

  def create
    answers = ServiceSurveys.generate_answer_records(answers_params, current_user.id, params[:cis_id])
    answers.each do |answer|
      answer = SurveyAnswer.new(answer)
      answer.save
    end
    @service_survey = ServiceSurvey.find(params[:service_survey_id])
    UserMailer.confirm_service_survey_answer(@service_survey, current_user).deliver
    redirect_to service_survey_reports_path(redirect_params), notice: t('.answers_created_successfully')
  end

  private

  def answers_params
    params.require(:answers).values
  end

  def redirect_params
    if @service_survey.reports.any?
      { id: @service_survey.reports.last.id }
    else
      { service_survey_id: @service_survey.id }
    end
  end

  def authorize_user_to_answer
    service_survey = ServiceSurvey.find(params[:service_survey_id])
    cis = params[:cis_id]
    if service_survey.has_been_answered_by?(current_user,cis)
      redirect_to service_surveys_path, notice: t('.answers_already_sent')
    end
  end

      def save_path
     session[:my_previous_url] = request.fullpath
  end

  def delete_path
    session[:my_previous_url] = nil
  end


end
