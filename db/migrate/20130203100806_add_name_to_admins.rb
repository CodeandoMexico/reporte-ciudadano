class AddNameToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :name, :string, default: ''
  end
end
