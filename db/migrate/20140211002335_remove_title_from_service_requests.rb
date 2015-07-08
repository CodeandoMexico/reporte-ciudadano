class RemoveTitleFromServiceRequests < ActiveRecord::Migration
  def change
    remove_column :service_requests, :title
    remove_column :service_requests, :phase
  end
end
