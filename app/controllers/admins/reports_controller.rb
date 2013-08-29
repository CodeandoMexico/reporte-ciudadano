class Admins::ReportsController < Admins::AdminController 

  def update_status
    @report = Report.find(params[:id])
    @report.update_attribute :status_id, params[:report][:status_id] 
    current_admin.comments.create content: params[:report][:message], report_id: @report.id
    redirect_to :back 
  end

  def update
    @report = Report.find params[:id] 
    if @report.update_attributes params[:report]
      redirect_to @report, flash: { success: "El reporte fue actualizado correctamente" }
    else
     render :edit 
    end
  end

  def edit
    @report = Report.find params[:id] 
  end

  def destroy
    @report = Report.find params[:id]
    @report.destroy
    redirect_to :back, flash: { success: "El reporte fue eliminado correctamente" }
  end
end
