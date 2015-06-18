class ServiceReportsController < ApplicationController
  def show
    @report = ServiceReport.report(params[:id])
  end
end
