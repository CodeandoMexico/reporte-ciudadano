class Admins::ServiceAdminsController < ApplicationController
  before_action :verify_super_admin_access
  before_action :set_services, only: [:new, :create]
  helper_method :dependency_options, :administrative_unit_options,:service_cis_options,:service_cis_options,:service_admins_name_options,:record_number_options
    before_action :set_search
  layout 'admins'

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(service_admin_params.merge(password: password, password_confirmation: password))
    if @admin.save
      AdminMailer.send_service_admin_account(admin: @admin).deliver
      redirect_to admins_service_admins_path, notice: t('flash.service_admin.created')
    else
      render :new
    end
  end

  def index
    load_services
  end

  def edit
    @admin = Admin.find(params[:id])
    @services = Service.for_service_admin(@admin)
  end

  def update
    @admin = Admin.find(params[:id])
    @services = Service.for_service_admin(@admin)
    if @admin.update_attributes(service_admin_params)
      redirect_to admins_service_admins_path, notice: t('flash.service_admin.updated')
    else
      render :edit
    end
  end

  def set_search
    @search = Admin.search(params[:q])
  end


  private

  def verify_super_admin_access
    @permissions = Admins.permissions_for_admin(current_admin)
    unless @permissions.can_manage_service_admins?
      redirect_to admins_dashboards_path
    end
  end

  def service_admin_params
    services = Service.where(id: params[:admin].delete(:services_ids))
    params
      .require(:admin)
      .permit(:name, :email, :record_number, :dependency, :administrative_unit, :charge)
      .merge(managed_services: services, is_service_admin: true)
  end

  def password
    @password ||= Devise.friendly_token.first(8)
  end

  def set_services
    @services ||= Service.unmanaged
  end

  def dependency_options
    Services.service_dependency_options
  end

  def administrative_unit_options
    Services.service_administrative_unit_options
  end

  def service_cis_options
    Services.service_cis_options
  end
  
  def service_admins_name_options
    Services.service_admins_name_options
  end

  def record_number_options
    Services.record_number_options
  end



  def load_services
        #search_service_paramas
      @services = Admin.service_admins_sorted_by_name      
        unless params[:q].nil? 
          @services =  @services.where(name:  params[:q][:name] ) unless params[:q][:name].blank?
          @services =  @services.where(dependency: params[:q][:dependency] ) unless params[:q][:dependency].blank?
          @services =   @services.where(administrative_unit: params[:q][:administrative_unit] ) unless params[:q][:administrative_unit].blank?
          @services =  @services.where(record_number:   params[:q][:record_number] ) unless  params[:q][:record_number].blank?
        end
        
        @service_admins = @services.page(params[:page]).per(25)
  end
end
