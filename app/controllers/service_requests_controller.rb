class ServiceRequestsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new]
  helper_method :service_cis_options, :service_cis_label

  def index
    @search = ServiceRequest.unscoped.search(params[:q])
    @service_requests = @search.result.page(params[:page])
    flash.now[:notice] = "No se encontraron solicitudes de servicio." if @service_requests.empty?
  end

  def new
    if current_user
      @service_request = current_user.service_requests.build
    else
      @service_request = ServiceRequest.new
    end
  end

  def create
    @service_request = current_user.service_requests.build(service_request_params)

    if @service_request.save
      notify_public_servants
      redirect_to root_path, flash: { success: 'La solicitud fue creada satisfactoriamente' }
    else
      flash[:notice] = "Hubo problemas, intenta de nuevo"
      render :new
    end
  end

  def show
    @service_request = ServiceRequest.find(params[:id])
    @comments = @service_request.comments.order("comments.created_at ASC")
  end

  def vote
    @service_request = ServiceRequest.find(params[:id])
    current_user.vote_for(@service_request)
    respond_to do |format|
      format.html { redirect_to service_requests_path, :notice => 'Voted' }
      format.js
    end
  end

  def markers_for_gmap
    service_requests = ServiceRequest.filter_by_search_311(params)
    respond_to do |format|
      format.json { render :json => service_requests }
    end
  end

  private

  def service_cis_options
    Services.service_cis_options
  end

  def service_cis_label(cis_id)
    Services.service_cis_label(cis_id)
  end

  def notify_public_servants
    public_servants = @service_request.public_servants
    public_servants.each do |public_servant|
      AdminMailer.notify_new_request(admin: public_servant, service_request: @service_request).deliver
    end
  end

  def service_request_params
    service_fields = params[:service_request].delete(:service_fields)
    params.require(:service_request).permit(:address, :status_id, :service_id, :description, :media, :anonymous, :cis).tap do |whitelisted|
      whitelisted[:service_fields] = service_fields || {}
    end
  end
end
