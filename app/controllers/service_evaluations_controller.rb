class ServiceEvaluationsController < ApplicationController
  def show
    @service = Service.includes(:service_surveys, :questions, :answers).find(params[:id])
    requested_survey = @service.service_surveys.find_by_id(params[:service_survey_id])
    @service_survey = requested_survey || @service.service_surveys.last
    @respondents = Kaminari.paginate_array(@service_survey.respondents).page(params[:page]).per(20)
  end
end