class Admins::ServiceSurveysController < ApplicationController
  layout 'admins'
  before_action :set_title
  helper_method :phase_options, :criterion_options, :answer_type_options, :services_for

  def index
    @service_surveys = Admins.surveys_for(current_admin)
    @service_survey_report = ServiceSurveyReport.new
  end

  def new
    @service_survey = ServiceSurvey.new
  end

  def create
    @service_survey = current_admin.service_surveys.new(service_survey_record)
    if @service_survey.save
      redirect_to admins_service_surveys_path, notice: t('flash.service_survey.created')
    else
      render :new
    end
  end

  def show
    @service_survey = ServiceSurvey.find(params[:id])
  end

  def edit
    @service_survey = ServiceSurvey.find(params[:id])
  end

  def update
    @service_survey = ServiceSurvey.find(params[:id])
    if @service_survey.update_attributes(service_survey_record)
      redirect_to admins_service_surveys_path, notice: t('flash.service_survey.updated')
    else
      render :edit
    end
  end

  def questions_text
    questions = ServiceSurveys.questions_collection_by_criterion(Question.all, translator: I18n.method(:t))
    render json: { questions: questions }
  end

  def change_status
    @service_survey = ServiceSurvey.find(params[:id])
    if @service_survey.update_attributes(service_survey_params)
      redirect_to admins_service_surveys_path, notice: t('flash.service_survey.updated')
    end
  end

  def invitation_user_mail
    unless params[:get][:body].empty?
      send_survey_user(params[:get][:body], "#{new_answer_url}?service_survey_id=#{params[:id].keys.first.to_s}")
      redirect_to admins_service_surveys_path, notice: t('flash.service_survey.emailsend')
    else
      redirect_to admins_service_surveys_path, notice: t('flash.service_survey.noemailsend')
    end
     
  end

  private
  def set_title
    @title_page = I18n.t('admins.service_surveys.index.service_surveys')
  end

  def service_survey_record
    ServiceSurveys.generate_hash_for_record(service_survey_params.symbolize_keys)
  end

  def service_survey_params
    params.require(:service_survey).permit(:title, :phase, :open, questions_attributes: [:criterion, :text, :answer_type, :value, :answer_rating_range, :optional, :_destroy, :id, answers: []], service_ids: [])
  end

  def phase_options
    ServiceSurveys.phase_options
  end

  def criterion_options
    ServiceSurveys.criterion_options
  end

  def answer_type_options
    ServiceSurveys.answer_type_options
  end

  def services_for(admin)
    Admins.services_for(admin)
  end
  def send_survey_user(mails, link)
    mailsplit = params[:get][:body].gsub(/\s+/, "").split(";")
      mailsplit.each do |mail |
      UserMailer.notify_user_new_surveys(mail,link).deliver
      end
    end
end
