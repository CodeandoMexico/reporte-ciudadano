class Admins::ServiceSurveyReportsController < ApplicationController
  layout 'admins'
  helper_method :service_cis_options
  helper_method :criterion_options,:service_reports
  #Metodo que se utiliza al crear reportes desde la vista de observador
  def create
    @service_survey_report = ServiceSurveyReport.new(service_survey_report_params)
    if @service_survey_report.save
      generate_services_and_cis_reports
      redirect_to  service_survey_report_path(@service_survey_report), notice: t('service_report.created')
    else
      redirect_to  admins_service_surveys_path, notice: t('service_report.no_reports')
    end
  end

  def index
    dynamic_reports_select
  end


  def make_report
    unless params[:post].blank?
      @start_date = params[:post][:start_date] 
      @services = params[:post][:services]
      @cis = params[:post][:cis]
      @end_date = params[:post][:end_date] 
      @criterio_name = params[:post][:criterio]
      @predetermined = params[:post][:predetermined]
      @commit = params[:commit]

      if @predetermined
        redirect_to admins_service_survey_reports_path({:report_type => get_report_type(@predetermined)})
      end

    end
      @report_table = nil
  end


  private

  def generate_services_and_cis_reports
    ReportsWorker.perform_async(@service_survey_report.service_survey_id)
  end

  def service_survey_report_params
    params.require(:service_survey_report).permit(:service_survey_id, :service_id)
  end
  def service_cis_options
    Services.service_cis_options
  end
  
  def criterion_options
    ServiceSurveys.criterion_options
  end

  def service_reports
    Services.service_reports
  end

  def dynamic_reports_select
    case params[:report_type]
      when "service_public_servants_report"
        @grid = DynamicReports::ServicePublicServantsReport.new(params[:dynamic_reports]) do |scope|
          scope.page(params[:page])
        end
      when "best_service_report"
        @grid = DynamicReports::BestServiceReport.new(params[:dynamic_reports]) do |scope|
          scope.page(params[:page])
        end
      when "service_status_report"
        @grid = DynamicReports::ServiceStatusReport.new(params[:dynamic_reports]) do |scope|
          scope.page(params[:page])
        end
      else
        @grid = DynamicReports::Panacea.new(params[:dynamic_reports]) do |scope|
          scope.page(params[:page])
      end
    end
  end


  def get_report_type(type)
    case type
      when "1"
        "service_status_report"
      when "2"
        "best_procedure_or_service"
      when "3"
        "best_service_report"
      when "4"
        "service_public_servants_report"
      when "5"
        "service_for_cis"
      when "6"
        "service_late"
      else 
        "default_report"
    end
  end

end
