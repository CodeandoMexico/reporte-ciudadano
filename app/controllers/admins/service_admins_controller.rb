class Admins::ServiceAdminsController < ApplicationController
  before_action :set_services, only: [:new, :create]
  layout 'admins'

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(service_admin_params)
    if @admin.save
      AdminMailer.send_account_invitation(admin: @admin, password: @password).deliver
      redirect_to admins_service_admins_path, notice: t('flash.service_admin.created')
    else
      render :new
    end
  end

  def index
    @service_admins = Admin.service_admins_sorted_by_name.page(params[:page]).per(25)
  end

  private

  def service_admin_params
    services = Service.where(id: params[:admin].delete(:services_ids))
    params
      .require(:admin)
      .permit(:name, :email, :record_number, :dependency, :administrative_unit, :charge)
      .merge(services: services, password: password, password_confirmation: password, is_service_admin: true)
  end

  def password
    @password ||= Devise.friendly_token.first(8)
  end

  def set_services
    @services ||= Service.not_assigned
  end
end
