class ServiceSurveysController < ApplicationController

  def index
    @services = Service.with_open_surveys.uniq(:id).page(params[:page]).per(20)
  end
end
