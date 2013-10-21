class Admins::ApiKeysController < Admins::AdminController 
  def create
    current_admin.create_api_key unless current_admin.api_key.present?
    redirect_to admins_categories_path 
  end

  def index
  end
end
