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
    if params["report_type"] && params["report_type"]["name"]
      params[:report_type] = params["report_type"]["name"].split("/").last
      params[:dynamic_reports] = {}.merge(:id => get_report_type(params[:report_type]))
    elsif params[:dynamic_reports] && params[:dynamic_reports][:id]
      params[:report_type] = get_report_type(params[:dynamic_reports][:id])
      params[:dynamic_reports] = {}.merge(:id => get_report_type(params[:report_type]))
    else
      params[:dynamic_reports] = {}.merge(:id => 0)
      params[:report_type] = get_report_type(params[:dynamic_reports][:id])
    end
    case params[:report_type]
      when "service_status_report"
        @grid = DynamicReports::ServiceStatusReport.new(params["dynamic_reports_service_status_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.service_status_report')
      when "best_service_report"
        @grid = DynamicReports::BestServiceReport.new(params["dynamic_reports_best_service_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.best_procedure_or_service')
      when "worst_service_report"
        @grid = DynamicReports::BestServiceReport.new(params["dynamic_reports_best_service_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.best_procedure_or_service')
      when "best_public_servants_report"
        @grid = DynamicReports::WorstPublicServantsReport.new(params["dynamic_reports_worst_public_servants_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.worst_public_servants_report')
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
        "best_service_report"
      when "3"
        "best_public_servants_report"
      when "4"
        "worst_public_servants_report"
      when "5"
        "service_public_servants_report"
      when "6"
        "service_demand_report"
      when "7"
        "cis_services_report"
      when "8"
        "service_performance_report"
      when "service_status_report"
        "1"
      when "best_service_report"
        "2"
      when "best_public_servants_report"
        "3"
      when "best_public_servants_report"
        "4"
      when "service_public_servants_report"
        "5"
      when "service_demand_report"
        "6"
      when "cis_services_report"
        "7"
      when "service_performance_report"
        "8"
      when "default_report"
        "1"
      else 
        "default_report"
    end
  end

end
