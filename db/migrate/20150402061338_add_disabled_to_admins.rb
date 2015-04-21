class AddDisabledToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :disabled, :boolean, default: false
  end
end
