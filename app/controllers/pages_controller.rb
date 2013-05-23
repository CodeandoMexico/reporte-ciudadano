class PagesController < ApplicationController
  def index
    @reports = Report.filter_by_search(params).page(params[:page])
    @open_reports = Report.not_closed.count
    @closed_reports = Report.closed.count
    @all_reports = Report.count
    @chart_data = Report.unscoped.select("category_id, count(case when status = 'open' then 1 end) as opened, 
                  count(case when status = 'verification' then 1 end) as verification, 
                  count(case when status = 'revision' then 1 end) as revision,
                  count(case when status = 'closed' then 1 end) as closed").group(:category_id).order('category_id').to_json
    @category_names = Category.order('id').pluck(:name).to_json 
    flash.now[:notice] = "No se encontraron reportes." if @reports.empty?
  end
end
