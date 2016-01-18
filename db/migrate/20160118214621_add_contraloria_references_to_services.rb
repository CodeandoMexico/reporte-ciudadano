class AddContraloriaReferencesToServices < ActiveRecord::Migration
  def change
    add_column :services, :comptroller_admin_id, :integer
    add_index  :services, :comptroller_admin_id
  end
end
