class Admins::PublicServantsController < ApplicationController
  helper_method :dependency_options, :administrative_unit_options
  layout 'admins'

  def index
    @public_servants = Admin.public_servants_sorted_by_name
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(public_servant_params)
    if @admin.save
      AdminMailer.send_public_servant_account(admin: @admin, password: @password).deliver
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

  private

  def public_servant_params
    params
      .require(:admin)
      .permit(:name, :email, :record_number, :dependency, :administrative_unit, :charge)
      .merge(password: password, password_confirmation: password, is_public_servant: true)
  end

  def password
    @password ||= Devise.friendly_token.first(8)
  end

  def dependency_options
    Services.service_dependency_options
  end

  def administrative_unit_options
    Services.service_administrative_unit_options
  end
end
