class Admins::ServiceAdminsController < ApplicationController
  before_action :verify_super_admin_access
  before_action :set_services
  before_action :set_title
  helper_method :dependency_options, :administrative_unit_options,:service_cis_options, :service_admins_name_options, :record_number_options
  before_action :set_search, only: :index
  layout 'admins'

  def index
    @service_admins = Admin.active.service_admins_sorted_by_name
    @disabled_service_admins = Admin.inactive.service_admins_sorted_by_name

    search_service_admins
  end

  def new
    @admin = Admin.new
    @services = Service.all
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

  def change_status
    @admin = Admin.find(params[:id])
    @admin.update_attributes(admin_status_params)
    redirect_to admins_service_admins_path, notice: t('flash.service_admin.updated')
  end

  private
  def set_title
    @title_page = I18n.t('admins.service_admins.index.service_admins')
  end

  def verify_super_admin_access
    @permissions = Admins.permissions_for_admin(current_admin)
    unless @permissions.can_manage_service_admins?
      redirect_to admins_dashboards_path
    end
  end

  def admin_status_params
    params.require(:admin).permit(:disabled, :active)
  end

  def service_admin_params
    services = Service.where(id: params[:admin].delete(:services_ids))
    params.require(:admin).permit(
      :name,
      :email,
      :record_number,
      :dependency,
      :administrative_unit,
      :charge,:second_surname,:surname
    )
    .merge(managed_services: services, is_service_admin: true)
  end

  def password
    @password ||= Devise.friendly_token.first(8)
  end

  def set_services
    @services = Service.unmanaged
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

  def search_service_admins
    if params[:q].present?
      @service_admins = @service_admins.where(id: params[:q][:id]) unless params[:q][:id].blank?
      @service_admins = @service_admins.where(dependency: params[:q][:dependency] ) unless params[:q][:dependency].blank?
      @service_admins = @service_admins.where(administrative_unit: params[:q][:administrative_unit] ) unless params[:q][:administrative_unit].blank?
      @service_admins = @service_admins.where(record_number: params[:q][:record_number] ) unless  params[:q][:record_number].blank?
    end
    @service_admins = @service_admins.page(params[:page]).per(25)
  end
end
