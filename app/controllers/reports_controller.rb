class ReportsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]

  def index
    @reports = Report.filter_by_search(params).page(params[:page])
  end

  def new
    @report = current_user.reports.build 
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
    @comments = @report.comments
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
