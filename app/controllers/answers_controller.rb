class AnswersController < ApplicationController
  before_action :save_path
  after_action :delete_path
  before_action :authenticate_user!, only: [:create, :new]
  before_action :authorize_user_to_answer, only: [:create, :new]

  def new
    service_survey = ServiceSurvey.find(params[:service_survey_id])
    @service_survey = ServiceSurveys.form_for_answers(service_survey)
    @cis_id = params[:cis_id]
    @service_id = params[:service_id]
  end

  def create
    answers = ServiceSurveys.generate_answer_records(answers_params, current_user.id, params[:cis_id], params[:service_id])
    @service_survey = ServiceSurvey.find(params[:service_survey_id])
    unless survey_has_been_answered
      answers.each do |answer|
        answer = SurveyAnswer.new(answer)
        answer.save
      end
      UserMailer.confirm_service_survey_answer(@service_survey, current_user).deliver
    end
    redirect_to redirect_after_answers, notice: t('.answers_created_successfully')
  end

  private
  def survey_has_been_answered
    ServiceSurvey.find(params[:service_survey_id]).
                                                  answers
                                                  .where( user_id: current_user.id,
                                                  cis_id: params[:cis_id],
                                                  service_id: params[:service_id] ).any?

  end

  def answers_params
    params.require(:answers).values
  end

  def redirect_after_answers
    reports = ServiceSurveyReport.where(cis_id: params[:cis_id],
                                        service_id: params[:service_id],
                                        service_survey_id: @service_survey.id)
                                  .order(:created_at)
    if reports.any?
      service_survey_report_path( id: reports.last.id)
    else
      root_path
    end
  end

  def authorize_user_to_answer
    service_survey = ServiceSurvey.find(params[:service_survey_id])

    cis = params[:cis_id]
    survey = params[:service_survey_id]
    service = params[:service_id]
    if service_survey.has_been_answered_by?(current_user, cis, service)
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
