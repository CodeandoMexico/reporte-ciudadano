class CreateAdminsServices < ActiveRecord::Migration
  def change
    create_table :admins_services do |t|
      t.integer :admin_id, null: false
      t.integer :service_id, null: false
    end
  end
end
