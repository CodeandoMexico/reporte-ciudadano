class ReportsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :new]

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

  def new
    if current_user
      @report = current_user.reports.build
    else
      @report = Report.new
    end
  end

  def create
    @report = current_user.reports.build(params[:report]) 
    if @report.save
      redirect_to root_path, flash: { success: 'Reporte creado satisfactoriamente' }
    else
      flash[:notice] = "Hubo problemas, intenta de nuevo"
      render :new
    end
  end

  def show
    @report = Report.find(params[:id])
    @comments = @report.comments.order("comments.created_at ASC")
  end

  def vote
    @report = Report.find(params[:id])
    current_user.vote_for(@report)
    respond_to do |format|
      format.html { redirect_to reports_path, :notice => 'Voted' }
      format.js 
    end
  end
end
