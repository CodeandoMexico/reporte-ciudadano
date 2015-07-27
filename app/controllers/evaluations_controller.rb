class EvaluationsController < ApplicationController
  before_action :authenticate_user_or_admin!

  def index
    services_records = Service.includes(:service_surveys, :answers).active
    @services = services_records.page(params[:page]).per(10)
    @cis = Evaluations.cis_with_results(available_cis, services_records)
  end

  private

  def available_cis
    Services.service_cis
  end
end
