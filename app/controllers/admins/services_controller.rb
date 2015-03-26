class Admins::ServicesController < Admins::AdminController

  def index
    @services = Service.all
    @statuses = Status.all
  end

  def new
    @service = Service.new
  end

  def edit
    @service = Service.find(params[:id])
  end

  def create
    @service = Service.new(service_params)

    if @service.save
      redirect_to admins_services_path, notice: I18n.t('flash.service.created')
    else
      render action: "new"
    end
  end

  def update
    @service = Service.find(params[:id])

    if @service.update_attributes(service_params)
      redirect_to admins_services_path, notice: I18n.t('flash.service.updated')
    else
      render action: "edit"
    end
  end

  def destroy
    @service = Service.find(params[:id])
    @service.destroy
    redirect_to admins_services_url, notice: I18n.t('flash.service.destroyed')
  end

  private

  def service_params
    params.require(:service).permit(:name, messages: [:content, :status_id], service_fields: [:name])
  end
end
