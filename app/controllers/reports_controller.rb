class ReportsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]

  def index
    @reports = Kaminari.paginate_array(Report.all).page(params[:page])
  end

  def new
    @report = current_user.reports.build 
  end

  def create
    @report = current_user.reports.build(params[:report]) 
    if @report.save
      redirect_to root_path, notice: 'Successfully created' 
    else
      render :new
    end
  end

  def show
    @report = Report.find(params[:id])
    @comments = @report.comments
  end

  
end
