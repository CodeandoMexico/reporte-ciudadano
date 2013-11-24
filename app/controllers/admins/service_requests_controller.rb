class Admins::ServiceRequestsController < Admins::AdminController 

  def index
    @search = ServiceRequest.unscoped.search(params[:q])
    @service_requests = @search.result.page(params[:page])
    flash.now[:notice] = "No se encontraron solicitudes." if @service_requests.empty?
  end

  def update
    @service_request = ServiceRequest.find params[:id]
    if @service_request.update_attributes params[:service_request]
      redirect_to edit_admins_service_request_path(@service_request), flash: { success: "La solicitud fue actualizada correctamente" }
    else
     render :edit 
    end
  end

  def edit
    @service_request = ServiceRequest.find params[:id]
    @comments = @service_request.comments.order("comments.created_at ASC")
  end

  def destroy
    @service_request = ServiceRequest.find params[:id]
    @service_request.destroy
    redirect_to :back, flash: { success: "La solicitud fue eliminada correctamente" }
  end


end
