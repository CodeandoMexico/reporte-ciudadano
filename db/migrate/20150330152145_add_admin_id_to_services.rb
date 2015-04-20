class AddAdminIdToServices < ActiveRecord::Migration
  def change
    add_reference :services, :admin, index: true
    add_foreign_key :services, :admins
  end
end
