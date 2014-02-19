class RemoveTitleFromServiceRequests < ActiveRecord::Migration
  def change
    remove_column :service_requests, :title
  end
end
