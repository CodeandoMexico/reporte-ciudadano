class CisEvaluationsController < ApplicationController
  layout 'observers'
  before_action :authorize_observer

  def index
    @cis = Evaluations.cis_with_results(available_cis, Service.all)
  end

  def show
    @cis = Evaluations.cis_evaluation_for(cis, Service.all)
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

  def cis
    available_cis.select { |cis| cis[:id].to_s ==  params[:id] }.first
  end
end
