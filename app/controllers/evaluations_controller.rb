class EvaluationsController < ApplicationController
  layout 'admins'
  helper_method :service_cis_options,
                :service_office_options,
                :service_name_options,
                :cis_options,
                :dependency_options

  before_action :authorize_observer
  before_action :set_search, only: :index
  before_action :authenticate_user_or_admin!

  def index
    services_records = Service.includes(:service_surveys, { answers: [:user] }, :admins)
                              .active
    @services = services_records.page(params[:page]).per(10)
    @cis = Evaluations.cis_with_results(available_cis, services_records)
    search_services
  end

  def service
    @service = Service.find(params[:service_id])
    @service_report = Evaluations.service_evaluation_for(@service)
  end

  private

  def set_search
    @search = Service.search(params[:q])
  end

  def service_cis_options
    Services.service_cis_options
  end

  def service_office_options
    Office.pluck(:name, :id)
  end

  def service_name_options
   @services.uniq.pluck(:name)
  end

  def dependency_options
   Services.service_dependency_options
  end

  def available_cis
    Services.service_cis
  end

  def search_services
    if params[:q].present?
      @services = @services.where(name: params[:q][:name] ) unless params[:q][:name].blank?
      @services = @services.where("cis ILIKE ANY ( array[?] )", "%#{params[:q][:cis]}%") unless params[:q][:cis].blank?
      @id_cis = params[:q][:cis] unless params[:q][:cis].blank?
    end
  end
end
