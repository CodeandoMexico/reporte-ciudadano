class Admins::StatusesController < Admins::AdminController
  before_action :set_status, only: [:edit, :update, :destroy, :change_status]

  def index
    @statuses = Status.all
  end

  def new
    @status = Status.new
  end

  def create
    @status = Status.new(status_params)
    if @status.save
      redirect_to admins_services_path, flash: { success: I18n.t('flash.status.created') }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @status.update_attributes(status_params)
      redirect_to admins_services_path, flash: { success: I18n.t('flash.status.updated') }
    else
      render :new
    end
  end

  def change_status
    @status.update_attributes(status_params)
    redirect_to admins_services_path, notice: t('flash.status.updated')
  end

  def destroy
    @status.destroy
    redirect_to admins_services_path, flash: { success: I18n.t('flash.status.deleted') }
  end

  private

  def set_status
    @status =  Status.unscoped.find(params[:id])
  end

  def status_params
    params.require(:status).permit(
      :name,
      :is_default,
      :status
    )
  end
end
