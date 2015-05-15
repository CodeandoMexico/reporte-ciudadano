class RemoveAdminIdFromServices < ActiveRecord::Migration
  def change
    remove_column :services, :admin_id, :integer
  end
end
