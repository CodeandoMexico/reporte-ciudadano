class AddActiveToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :active, :boolean, default: false
  end
end
