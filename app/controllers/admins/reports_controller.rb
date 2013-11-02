class Admins::ReportsController < Admins::AdminController 

  def index
    @search = Report.unscoped.search(params[:q])
    @reports = @search.result.page(params[:page])
    flash.now[:notice] = "No se encontraron reportes." if @reports.empty?
  end

  def update_status
    @report = Report.find(params[:id])
    @report.update_attribute :status_id, params[:report][:status_id] 
    current_admin.comments.create content: params[:report][:message], report_id: @report.id
    redirect_to :back 
  end

  def update
    @report = Report.find params[:id] 
    if @report.update_attributes params[:report]
      redirect_to edit_admins_report_path(@report), flash: { success: "El reporte fue actualizado correctamente" }
    else
     render :edit 
    end
  end

  def edit
    @report = Report.find params[:id]
    @comments = @report.comments.order("comments.created_at ASC")
  end

  def destroy
    @report = Report.find params[:id]
    @report.destroy
    redirect_to :back, flash: { success: "El reporte fue eliminado correctamente" }
  end

  def dashboard
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
