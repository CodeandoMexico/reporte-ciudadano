class AddDefaultValuesToAdmins < ActiveRecord::Migration
  def change
    change_column :admins, :is_service_admin, :boolean, default: false
    change_column :admins, :is_public_servant, :boolean, default: false
  end
end
