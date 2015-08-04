class ServiceSurveysController < ApplicationController
before_action :authenticate_user!
  def index
    @service_surveys = ServiceSurvey.open.page(params[:page]).per(20)
  end
end
