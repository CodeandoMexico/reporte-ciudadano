class Admins::ApiKeysController < Admins::AdminController 
  before_action :set_title
  def create
    current_admin.create_api_key unless current_admin.api_key.present?
    redirect_to admins_services_path
  end

  def index
  end

  private
  def set_title
    @title_page = I18n.t('admins.api_keys.index.header')
  end
end
