class CreateServiceRequestReadings < ActiveRecord::Migration
  def change
    create_table :service_request_readings do |t|
      t.references :service_request, index: true
      t.references :admin, index: true

      t.timestamps null: false
    end
    add_foreign_key :service_request_readings, :service_requests
    add_foreign_key :service_request_readings, :admins
  end
end
