class AddServiceIdToAdmins < ActiveRecord::Migration
  def change
    add_reference :admins, :service, index: true
    add_foreign_key :admins, :services
  end
end
