class AddCisToServiceRequests < ActiveRecord::Migration
  def change
    add_column :service_requests, :cis, :string
  end
end
