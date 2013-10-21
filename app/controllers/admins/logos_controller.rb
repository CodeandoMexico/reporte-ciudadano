class Admins::LogosController < Admins::AdminController

  before_filter :get_logo, only: [:edit, :update, :destroy]

  def new
    @logo = Logo.new
  end

  def create
    @logo = Logo.new(params[:logo])
    if @logo.save
      redirect_to design_admins_dashboards_path, notice: t('flash.logo.created')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @logo.update_attributes params[:logo]
      redirect_to design_admins_dashboards_path, notice: t('flash.logo.updated')
    else
      render :edit
    end
  end

  def destroy
    @logo.destroy
    redirect_to design_admins_dashboards_path, notice: t('flash.logo.destroyed')
  end

  def rearrange
    params[:logo].each_with_index do |logo_id, position|
      Logo.update(logo_id.to_i, position: position)
    end
    render text: 'ok'
  end

  private

  def get_logo
    @logo = Logo.find(params[:id])
  end


end
