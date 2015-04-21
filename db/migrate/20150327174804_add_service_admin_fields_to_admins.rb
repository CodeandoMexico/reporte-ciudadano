class AddServiceAdminFieldsToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :record_number, :string
    add_column :admins, :dependency, :string
    add_column :admins, :administrative_unit, :string
    add_column :admins, :charge, :string
  end
end
