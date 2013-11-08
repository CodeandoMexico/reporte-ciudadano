class ServiceRequestsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :new]

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
    @service_request = current_user.service_requests.build(params[:service_request])
    if @service_request.save
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
end
