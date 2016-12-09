class AddPubvlicServantToServiceRequests < ActiveRecord::Migration
  def up
    add_column :service_requests, :public_servant_id, :integer
    add_column :service_requests, :public_servant_description, :text
  end

  def down
    remove_column :service_requests, :public_servant_description, :text
    remove_column :service_requests, :public_servant_id, :integer
  end
end
