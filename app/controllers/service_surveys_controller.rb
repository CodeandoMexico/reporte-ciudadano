class ServiceSurveysController < ApplicationController
before_action :authenticate_user!
  def index
    params[:q] ||= {}
    @q = Service.preload(:service_surveys)
                       .with_open_surveys
                       .uniq(:id)
                       .ransack(params[:q])

    @services = @q.result.page(params[:page])
                         .per(20)
  end
end
