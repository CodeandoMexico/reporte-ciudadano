class AddAdminsReferencesToServices < ActiveRecord::Migration
  def change
    add_column :services, :service_admin_id, :integer
    add_index  :services, :service_admin_id
  end
end
