class AddAdminIdToApiKeys < ActiveRecord::Migration
  def change
    add_column :api_keys, :admin_id, :integer
    add_index :api_keys, :admin_id
  end
end
