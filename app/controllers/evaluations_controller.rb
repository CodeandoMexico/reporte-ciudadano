class EvaluationsController < ApplicationController
  layout 'observers'
  helper_method :service_cis_options, :service_name_options, :cis_options, :dependency_options
  before_action :authenticate_user!
  before_action :authorize_observer
  before_action :set_search

  def index
    load_services
  end

   def service_cis_options
    Services.service_cis_options
  end
  
  def service_name_options
   @services.uniq.pluck(:name)
  end

  def dependency_options
   Services.service_dependency_options
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

  def set_search
    @search = Service.search(params[:q])
  end

  def load_services
          services_records = Service.includes(:service_surveys, :answers).active
          @services = services_records.page(params[:page]).per(10)
          @cis = Evaluations.cis_with_results(available_cis, services_records)

        unless params[:q].nil? 
          @services =  @services.where(name:  params[:q][:name] ) unless params[:q][:name].blank?
          @services =  @services.where("cis ILIKE ANY ( array[?] )", "%#{params[:q][:cis]}%") unless params[:q][:cis].blank?
          @id_cis  =   params[:q][:cis] unless params[:q][:cis].blank?
        end
  end
end
