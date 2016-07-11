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

  #TODO: mover esta funcionalidad de crear reportes dinámicos a
  # un controlador de reportes dinámicos.
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
    params.require(:service_survey_report).permit(:service_survey_id, :service_id, :cis_id)
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
    elsif
      params.keys.count == 3
      current_report_name_array = params.keys.first.split("_")
      params[:report_type] = current_report_name_array.last(current_report_name_array.count - 2).join("_").to_s
      params[:dynamic_reports] = {}.merge(:id => get_report_type(params[:report_type]))
    else
      params[:dynamic_reports] = {}.merge(:id => 0)
      params[:report_type] = get_report_type(params[:dynamic_reports][:id])
    end
    case params[:report_type]
      when "service_status_report"
        @grid = DynamicReports::ServiceStatusReport.new(params["dynamic_reports_service_status_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.service_status_report')
      when "all_service_report"
        @grid = DynamicReports::AllServiceReport.new(params["dynamic_reports_all_service_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.all_procedure_or_service')
      when "best_service_report"
        @grid = DynamicReports::BestServiceReport.new(params["dynamic_reports_best_service_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.best_procedure_or_service')
      when "worst_service_report"
        @grid = DynamicReports::WorstServiceReport.new(params["dynamic_reports_worst_service_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.worst_procedure_or_service')
      when "all_public_servants_report"
        @grid = DynamicReports::AllPublicServantsReport.new(params["dynamic_reports_all_public_servants_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.all_public_servants_report')
      when "best_public_servants_report"
        @grid = DynamicReports::BestPublicServantsReport.new(params["dynamic_reports_best_public_servants_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.best_public_servants_report')
      when "worst_public_servants_report"
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
      when "services_all_information_report"
        @grid = DynamicReports::ServicesAllInformationReport.new(params["dynamic_reports_services_all_information_report"])
        @title = I18n.t('activerecord.attributes.dynamic_reports.type.services_all_information_report')
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
        "all_service_report"
      when "3"
        "best_service_report"
      when "4"
        "worst_service_report"
      when "5"
        "all_public_servants_report"
      when "6"
        "best_public_servants_report"
      when "7"
        "worst_public_servants_report"
      when "8"
        "service_public_servants_report"
      when "9"
        "service_demand_report"
      when "10"
        "cis_services_report"
      when "11"
        "service_performance_report"
      when "12"
        "services_all_information_report"


      when "service_status_report"
        "1"
      when  "all_service_report"
        "2"
      when "best_service_report"
        "3"
      when "worst_service_report"
        "4"
      when "all_public_servants_report"
        "5"
      when "best_public_servants_report"
        "6"
      when "worst_public_servants_report"
        "7"
      when "service_public_servants_report"
        "8"
      when "service_demand_report"
        "9"
      when "cis_services_report"
        "10"
      when "service_performance_report"
        "11"
      when "services_all_information_report"
        "12"
      when "default_report"
        "1"
      else 
        "default_report"
    end
  end

end
