class RemoveLatLngFromServiceRequests < ActiveRecord::Migration
  def change
    remove_column :service_requests, :lat, :string
    remove_column :service_requests, :lng, :string
  end
end
