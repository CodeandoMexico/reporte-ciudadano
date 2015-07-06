class Admins::PublicServantsController < ApplicationController
  helper_method :dependency_options, :administrative_unit_options, :is_assigned_to_public_servant?
  before_action :set_title
  layout 'admins'

  def index
    @public_servants = Admins.public_servants_for(current_admin)
    @disabled_public_servants = Admins.disabled_public_servants_for(current_admin)
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(public_servant_params)
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

  private

  def set_title
    @title_page = I18n.t('admins.public_servants.index.public_servants')
  end

  def public_servant_params
    if params[:admin].present?
      services = Service.where(id: params[:admin][:services_ids])
    else
      services = []
    end

    params
      .require(:admin)
      .permit(:name, :email, :record_number, :dependency, :administrative_unit, :charge)
      .merge(services: services, password: password, password_confirmation: password, is_public_servant: true)
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
end
