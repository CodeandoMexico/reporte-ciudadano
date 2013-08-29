class PagesController < ApplicationController
  def index
    @reports = Report.filter_by_search(params).page(params[:page])
    @open_reports = Report.not_closed.count
    @closed_reports = Report.closed.count
    @all_reports = Report.count
    @chart_data = Report.chart_data.to_json
    @category_names = Category.order('id').pluck(:name).to_json 
    @status_names = Status.pluck(:name).to_json 
    flash.now[:notice] = "No se encontraron reportes." if @reports.empty?
  end
end
