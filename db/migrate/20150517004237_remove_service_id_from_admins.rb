class RemoveServiceIdFromAdmins < ActiveRecord::Migration
  def change
    remove_column :admins, :service_id, :integer
  end
end
