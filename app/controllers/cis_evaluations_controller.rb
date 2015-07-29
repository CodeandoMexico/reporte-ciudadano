class CisEvaluationsController < ApplicationController
  layout 'observers'
  helper_method :criterions
  before_action :authenticate_user!
  before_action :authorize_observer
    before_action :set_search
    helper_method :service_cis_options, :service_name_options

  def index
    services_records = Service.includes(:service_surveys, :service_reports, :answers, :service_surveys_reports).active
    @cis = Evaluations.cis_with_results(available_cis, services_records)
  end

  def show
    load_services

    
  end

  def set_search
    @search = Service.search(params[:q])
  end

  
  def service_name_options
   @services
  end

    def service_administrative_unit
   @services
  end

  private

  def sorted_services(services)
    return services unless params[:sort_by].present?

    sorted = services.sort_by do |service|
      [service.overall_evaluation_for(params[:sort_by].to_sym) ? 1 : 0, service.overall_evaluation_for(params[:sort_by].to_sym)]
    end

    if params[:direction] == 'asc'
      sorted
    else
      sorted.reverse
    end
  end

  def toggle_sort_direction
    return :desc if params[:direction] == "asc"
    :asc
  end

  def criterions
    ServiceSurveys.criterion_options_available
  end

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

    def load_services
      services_records = Service.includes(:service_surveys, :service_reports, :answers, :service_surveys_reports).active
      @cis = Evaluations.cis_evaluation_for(cis, services_records)
        unless params[:q].nil? 
          @id_name  =   params[:q][:name] unless params[:q][:name].blank?
          #@cis  =   @cis.merge(:administrative_unit => params[:q][:administrative_unit]) unless params[:q][:administrative_unit].blank?
        end
        
      @cis_report = Reports.current_cis_report_for(
      cis,
      cis_report_store: CisReport,
      survey_reports: @cis.services.map(&:last_survey_reports).flatten,
      translator: I18n.method(:t))
      @services = sorted_services(@cis.services)
      @next_possible_direction = toggle_sort_direction
      @sorted_by = params[:sort_by]

  end
end
