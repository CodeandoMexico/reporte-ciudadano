class ServiceSurveysController < ApplicationController
before_action :authenticate_user!
  def index
    @services = Service.preload(:service_surveys)
                       .with_open_surveys
                       .uniq(:id)
                       .page(params[:page])
                       .per(20)
  end
end
