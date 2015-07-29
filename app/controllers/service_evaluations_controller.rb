class ServiceEvaluationsController < ApplicationController
  before_action :authenticate_user_or_admin!
  before_action :authorize_observer
  helper_method :can_ignore_answers?

  def show
    @service = Service.includes(:service_surveys, :questions, :answers).find(params[:id])
    requested_survey = @service.service_surveys.find_by_id(params[:service_survey_id])
    @service_survey = requested_survey || @service.service_surveys.last
    @respondents = Kaminari.paginate_array(@service_survey.respondents).page(params[:page]).per(20)
  end

  private

  def can_ignore_answers?(admin)
    admin && (admin.is_super_admin? || admin.is_service_admin?)
  end
end