class ServiceSurveysController < ApplicationController

  def index
    @service_surveys = ServiceSurvey.open.page(params[:page]).per(20)
  end
end
