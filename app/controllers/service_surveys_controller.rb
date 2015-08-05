class ServiceSurveysController < ApplicationController
before_action :authenticate_user!
  def index
    @services = Service.with_open_surveys.uniq(:id).page(params[:page]).per(20)
  end
end
