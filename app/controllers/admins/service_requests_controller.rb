class Admins::ServiceRequestsController < Admins::AdminController 

  def index
    @search = ServiceRequest.unscoped.search(params[:q])
    @service_requests = @search.result.page(params[:page])
    flash.now[:notice] = I18n.t('flash.dashboards.requests_not_found') if @service_requests.empty?
  end

  def new
    @service_request = ServiceRequest.new
  end

  def create
    @service_request = current_admin.service_requests.build(service_request_params)
    if @service_request.save
      redirect_to edit_admins_service_request_path(@service_request), flash: { success: I18n.t('flash.service_requests.created') }
    else
      flash[:notice] = t('flash.service_requests.try_again')
      render :new
    end
  end

  def edit
    @service_request = ServiceRequest.find params[:id]
    @messages = @service_request.service.messages.with_status(@service_request.status_id)
    @comments = @service_request.comments.order("comments.created_at ASC")
  end

  def update
    @service_request = ServiceRequest.find params[:id]
    if @service_request.update_attributes(service_request_params)
      @service_request.comments.create content: params[:message], commentable: current_admin if params[:message].present?
      redirect_to edit_admins_service_request_path(@service_request), flash: { success: I18n.t('flash.service_requests.updated') }
    else
     render :edit
    end
  end

  def destroy
    @service_request = ServiceRequest.find params[:id]
    @service_request.destroy
    redirect_to :back, flash: { success: I18n.t('flash.service_requests.destroyed') }
  end

  private

  def service_request_params
    params.require(:service_request).permit(:name, :status_id, :service_fields_attributes, :messages_attributes)
  end
end
