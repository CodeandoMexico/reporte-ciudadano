class Admins::PublicServantsController < ApplicationController
  helper_method :dependency_options, :administrative_unit_options, :is_assigned_to_public_servant?,:service_cis_options,:public_servants_name_options,:record_number_options
    before_action :set_search
  layout 'admins'

  def index
        load_services
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(public_servant_params.merge(password: password, password_confirmation: password))
    if @admin.save
      AdminMailer.send_public_servant_account(admin: @admin).deliver
      redirect_to admins_public_servants_path, notice: t('flash.public_servant.created')
    else
      render :new
    end
  end

  def edit
    @admin = Admin.find_by_id(params[:id])
  end

  def update
    @admin = Admin.find(params[:id])
    if @admin.update_attributes(public_servant_params)
      redirect_to admins_public_servants_path, notice: t('flash.public_servant.updated')
    else
      render :edit
    end
  end

  def disable
    @admin = Admin.find(params[:id])
    @admin.update_attributes(disabled: true)
    redirect_to admins_public_servants_path, notice: t('flash.public_servant.disabled')
  end

  def enable
    @admin = Admin.find(params[:id])
    @admin.update_attributes(disabled: false)
    redirect_to admins_public_servants_path, notice: t('flash.public_servant.enabled')
  end

  def assign_services
    @public_servant = Admin.find(params[:id])
    @available_services = Admins.services_for(current_admin)
  end

   def set_search
    @search = Service.search(params[:q])
  end

  private

  def public_servant_params
    if params[:admin].present?
      services = Service.where(id: params[:admin][:services_ids])
    else
      services = []
    end

    params
      .require(:admin)
      .permit(:name, :email, :record_number, :dependency, :administrative_unit, :charge)
      .merge(services: services, is_public_servant: true)
  end

  def password
    @password ||= Devise.friendly_token.first(8)
  end

  def dependency_options
    if current_admin.is_super_admin?
      Services.service_dependency_options
    else
      [current_admin.dependency]
    end
  end

  def administrative_unit_options
    Services.service_administrative_unit_options
  end

  def is_assigned_to_public_servant?(service, public_servant)
    Services.is_assigned_to_public_servant?(service, public_servant)
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
  
  def public_servants_name_options
    Services.public_servants_name_options(current_admin)
  end

  def record_number_options
    Services.record_number_options
  end

  def load_services
        #search_service_paramas
      @public_servants = Admins.public_servants_for(current_admin)
      @disabled_public_servants = Admins.disabled_public_servants_for(current_admin)

        unless params[:q].nil? 
          @public_servants =  @public_servants.where(name:  params[:q][:name] ) unless params[:q][:name].blank?
          @public_servants =  @public_servants.where(dependency: params[:q][:dependency]) unless params[:q][:dependency].blank?
          @public_servants =   @public_servants.where(administrative_unit: params[:q][:administrative_unit] ) unless params[:q][:administrative_unit].blank?

          @disabled_public_servants =  @disabled_public_servants.where(name:   params[:q][:name] ) unless params[:q][:name].blank?
          @disabled_public_servants =  @disabled_public_servants.where(dependency: params[:q][:dependency] ) unless params[:q][:dependency].blank?
          @disabled_public_servants =   @disabled_public_servants.where(administrative_unit: params[:q][:administrative_unit] ) unless params[:q][:administrative_unit].blank?
        end

  end
end
