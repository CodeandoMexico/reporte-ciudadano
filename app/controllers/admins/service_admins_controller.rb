class Admins::ServiceAdminsController < ApplicationController
  before_action :verify_super_admin_access
  before_action :set_services, only: [:new, :create]
  before_action :set_title
  helper_method :dependency_options, :administrative_unit_options
  layout 'admins'

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(service_admin_params)
    if @admin.save
      AdminMailer.send_service_admin_account(admin: @admin).deliver
      redirect_to admins_service_admins_path, notice: t('flash.service_admin.created')
    else
      render :new
    end
  end

  def index
    @service_admins = Admin.service_admins_sorted_by_name.page(params[:page]).per(25)
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

  def service_admin_params
    services = Service.where(id: params[:admin].delete(:services_ids))
    params
      .require(:admin)
      .permit(:name, :email, :record_number, :dependency, :administrative_unit, :charge)
      .merge(managed_services: services, password: password, password_confirmation: password, is_service_admin: true)
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
end
