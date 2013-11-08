class AddStatusIdToServiceRequests < ActiveRecord::Migration
  def change
    add_column :service_requests, :status_id, :integer
    add_index :service_requests, :status_id
  end
end
