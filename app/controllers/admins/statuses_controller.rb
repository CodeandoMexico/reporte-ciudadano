class Admins::StatusesController < Admins::AdminController

  def index
    @statuses = Status.all 
  end

  def new
    @status = Status.new 
  end

  def create
    @status = Status.new(params[:status])
    if @status.save
      redirect_to admins_services_path, flash: { success: I18n.t('flash.status.created')}
    else
      render :new
    end
  end

  def edit
    @status = Status.find(params[:id]) 
  end

  def update
    @status = Status.find(params[:id]) 
     if @status.update_attributes(params[:status])
      redirect_to admins_services_path, flash: { success: I18n.t('flash.status.updated')}
    else
      render :new
     end
  end
end
