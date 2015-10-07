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
    unless params[:dynamic_reports].blank?
      if params[:dynamic_reports][:id].nil?
        params[:dynamic_reports][:id] = 0
      end
      params[:report_type] = get_report_type(params[:dynamic_reports][:id])
    else
      params[:dynamic_reports] = {}.merge(:id => 0)
    end
    dynamic_reports_select
    respond_to do |f|
      f.html do
        @grid.scope do |scope|
          scope.page(params[:page])
        end
        @title
      end
      f.csv do
        send_data @grid.to_csv.encode!(Encoding::ISO_8859_1),
                  type: "text/csv; charset=iso-8859-1; header=present'",
                  disposition: 'inline',
                  filename: "#{params[:report_type]}-#{Time.now.to_s}.csv"
      end
    end
  end


  def make_report
    redirect_to admins_service_survey_reports_path(params)
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
      when "service_status_report"
        @grid = DynamicReports::ServiceStatusReport.new(params["dynamic_reports_service_status_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.service_status_report')
      when "best_procedure_or_service"
        @grid = DynamicReports::BestServiceReport.new(params["dynamic_reports_best_service_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.best_procedure_or_service')
      when "best_public_servants_report"
        @grid = DynamicReports::BestPublicServantsReport.new(params["dynamic_reports_best_public_servants_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.best_public_servants_report')
      when "service_public_servants_report"
        @grid = DynamicReports::ServicePublicServantsReport.new(params["dynamic_reports_service_public_servants_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.service_public_servants_report')
      when "service_demand_report"
        @grid = DynamicReports::ServiceDemandReport.new(params["dynamic_reports_service_demand_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.service_demand_report')
      when "cis_services_report"
        @grid = DynamicReports::CisServicesReport.new(params["dynamic_reports_cis_services_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.cis_services_report')
      when "service_performance_report"
        @grid = DynamicReports::ServicePerformanceReport.new(params["dynamic_reports_service_performance_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.service_performance_report')
      else
        @grid = DynamicReports::ServiceStatusReport.new(params["dynamic_reports_service_status_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.service_status_report')
    end
  end


  def get_report_type(type)
    case type
      when "1"
        "service_status_report"
      when "2"
        "best_procedure_or_service"
      when "3"
        "best_public_servants_report"
      when "4"
        "service_public_servants_report"
      when "5"
        "service_demand_report"
      when "6"
        "cis_services_report"
      when "7"
        "service_performance_report"
      else 
        "default_report"
    end
  end

end
