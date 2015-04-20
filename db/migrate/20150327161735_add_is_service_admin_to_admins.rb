class AddIsServiceAdminToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :is_service_admin, :boolean
  end
end
