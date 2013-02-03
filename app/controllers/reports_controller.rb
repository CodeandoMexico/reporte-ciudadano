class ReportsController < ApplicationController

  def index
  end

  def new
    @report = Report.new 
  end

  def create
    @report = Report.new(params[:report]) 
    if @report.save
      redirect_to root_path, notice: 'Successfully created' 
    else
      render :new
    end
  end

  
end
