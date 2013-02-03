class Admins::ReportsController < Admins::AdminController 

  def update_status
    @report = Report.find(params[:id])
    @report.update_attribute :status, params[:report][:status] 
    redirect_to :back 
  end
end
