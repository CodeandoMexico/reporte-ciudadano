class CreateServiceRequests < ActiveRecord::Migration
  def change
    create_table :service_requests do |t|
      t.string :description,        default: ''
      t.string :lat,                default: ''
      t.string :lng,                default: ''
      t.boolean :anonymous,         default: false
      t.text :service_fields,       default: '{}'
      t.text :address,              default: ''
      t.string :title,              default: ''

      t.string :media
      t.integer :service_id
      t.references :requester,      polymorphic: true, null: false

      t.timestamps
    end

    add_index :service_requests, :service_id
    add_index :service_requests, [:requester_id, :requester_type]
  end
end
