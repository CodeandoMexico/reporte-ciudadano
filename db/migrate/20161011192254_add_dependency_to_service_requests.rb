class AddDependencyToServiceRequests < ActiveRecord::Migration
  def change
    add_column :service_requests, :dependency, :string
  end
end
