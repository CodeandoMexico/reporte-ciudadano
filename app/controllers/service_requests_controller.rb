class ServiceRequestsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new, :index, :show]
  before_action :create_array, only: [:create, :new]
  helper_method :service_cis_options, :service_cis_label

  def index
    @search = ServiceRequest.where(user_id: current_user).search()
    @service_requests = @search.result.page(params[:page])
    flash.now[:notice] = I18n.t("flash.service_requests.empty") if @service_requests.empty?
  end

  def new
    if current_user
      @service_request = current_user.service_requests.build
    else
      @service_request = ServiceRequest.new
    end
    service_public_servants
  end

  def create
    @service_request = current_user.service_requests.build(service_request_params)
    @service_request.user_id = current_user.id
    if @service_request.save
      notify_public_servants(@service_request)
      notify_user(@service_request)
      redirect_to root_path, flash: { success: I18n.t("flash.service_requests.success")}
    else
      flash[:notice] = I18n.t("flash.service_requests.error")
      render :new
    end
  end

  def show
    @service_request = ServiceRequest.find(params[:id])
    @comments = @service_request.comments.order("comments.created_at ASC")
    @public_servants = Admin.where(id: @service_request.public_servant_id).last
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
  def service_public_servants
    unless params[:pagetime].blank?
        unless params[:pagetime][:service].blank?
          service =  Service.find(params[:pagetime][:service])
        end
      unless service.blank?
        @admins_services = service.admins
      end
      @who = params[:pagetime][:who]
      respond_to do |format|
        format.js
      end
    end
  end

  def service_cis_options
    Services.service_cis_options
  end

  def service_cis_label(cis_id)
    Services.service_cis_label(cis_id)
  end

  def notify_public_servants(service_request)
    if service_request.public_servant_id.present? && !service_request.public_servant_id.zero?
      AdminMailer.notify_new_request(admin: Admin.find(service_request.public_servant_id), service_request: service_request).deliver
    end
  end

    def notify_user(service_request)
    if service_request.public_servant_id.present? && !service_request.public_servant_id.zero?
      UserMailer.notify_new_request(admin: Admin.find(service_request.public_servant_id), service_request: service_request).deliver
    end
  end

  def service_request_params
    service_fields = params[:service_request].delete(:service_fields)
    params.require(:service_request).permit(:address, :status_id, :service_id, :description, :media, :anonymous, :cis, :public_servant_id, :public_servant_description, :homoclave,:user_id).tap do |whitelisted|
      whitelisted[:service_fields] = service_fields || {}
    end
  end

  def create_array
    @array_line=[]
    @array_id=[]
    @public_servant_admins  = Service.last.admins
  end
end
