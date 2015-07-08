class EvaluationsController < ApplicationController
  layout 'observers'
  before_action :authorize_observer

  def index
    @services = Service.all.page(params[:page]).per(10)
    @cis = Evaluations.cis_with_results(available_cis, Service.all)
  end

  private

  def authorize_observer
    unless current_user.is_observer?
      redirect_to root_path
    end
  end

  def available_cis
    Services.service_cis
  end
end
