class Admins::PublicServantsController < ApplicationController

  helper_method :dependency_options,
                :organisation_options,
                :administrative_unit_options,
                :agency_options,
                :is_assigned_to_public_servant?,
                :service_cis_options,
                :public_servants_name_options,
                :record_number_options

  before_action :set_search, only: :index
  before_action :set_title
  layout 'admins'

  def index
    params[:q] ||= {}
    @public_servants = Admins.public_servants_for(current_admin)
    @disabled_public_servants = Admins.disabled_public_servants_for(current_admin)
    @public_servants_record_number = @public_servants.pluck(:record_number)
    search_public_servants
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params.merge(password: password, password_confirmation: password))
    if @admin.save
      send_admin_email(@admin)
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
    @search = Admin.search(params[:q])
  end

  private

  def admin_params
    return comptroller_params if (params[:admin][:is_comptroller] == "1" || params[:admin][:is_evaluation_comptroller] == "1")
    public_servant_params
  end

  def send_admin_email(admin)
    if admin.is_comptroller? || admin.is_evaluation_comptroller?
      AdminMailer.send_comptroller_account(admin: admin).deliver
    else
      AdminMailer.send_public_servant_account(admin: @admin).deliver
    end
  end

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
    .permit(
      :name,
      :email,
      :record_number,
      # :dependency,
      # :administrative_unit,
      :organisation_id,
      :agency_id,
      :charge,
      :surname,
      :second_surname,
      :is_observer,
      :is_comptroller)
    .merge(services: services, is_public_servant: true)
  end

  def comptroller_params
    params
    .require(:admin)
    .permit(
      :name,
      :email,
      :record_number,
      # :dependency,
      # :administrative_unit,
      :organisation_id,
      :agency_id,
      :charge,
      :surname,
      :second_surname,
      :is_comptroller,
      :is_evaluation_comptroller)
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

  def organisation_options
    if current_admin.is_super_admin?
      Organisation.pluck(:name, :id)
    else
      [
        [current_admin.organisation.name, current_admin.organisation.id]
      ]
    end
  end

  def is_assigned_to_public_servant?(service, public_servant)
    Services.is_assigned_to_public_servant?(service, public_servant)
  end

 # def dependency_options
 #    Services.service_dependency_options
 #  end

  # def administrative_unit_options
  #   Services.service_administrative_unit_options
  # end

  def agency_options
    Agency.pluck(:name, :id)
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

  def search_public_servants
    if params[:q].present?
      @public_servants = @public_servants.where(id: params[:q][:id]) unless params[:q][:id].blank?
      # @public_servants = @public_servants.where(dependency: params[:q][:dependency]) unless params[:q][:dependency].blank?
      @public_servants = @public_servants.where(organisation_id: params[:q][:organisation_id]) unless params[:q][:organisation_id].blank?
      # @public_servants = @public_servants.where(administrative_unit: params[:q][:administrative_unit] ) unless params[:q][:administrative_unit].blank?
      @public_servants = @public_servants.where(agency_id: params[:q][:agency_id] ) unless params[:q][:agency_id].blank?
      @public_servants = @public_servants.where(record_number:  params[:q][:record_number] ) unless params[:q][:record_number].blank?

      @disabled_public_servants = @disabled_public_servants.where(id: params[:q][:id]) unless params[:q][:id].blank?
      # @disabled_public_servants = @disabled_public_servants.where(dependency: params[:q][:dependency] ) unless params[:q][:dependency].blank?
      @disabled_public_servants = @disabled_public_servants.where(organisation_id: params[:q][:organisation_id] ) unless params[:q][:organisation_id].blank?
      # @disabled_public_servants = @disabled_public_servants.where(administrative_unit: params[:q][:administrative_unit] ) unless params[:q][:administrative_unit].blank?
      @disabled_public_servants = @disabled_public_servants.where(agency_id: params[:q][:agency_id] ) unless params[:q][:agency_id].blank?
      @disabled_public_servants = @disabled_public_servants.where(record_number: params[:q][:record_number] ) unless params[:q][:record_number].blank?
    end
  end
end
