class AddClassificationToServiceRequests < ActiveRecord::Migration
  def change
    add_column :service_requests, :classification, :string
  end
end
