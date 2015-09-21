class AddColumnIdUserToServiceRequests < ActiveRecord::Migration
 def up
    add_column :service_requests, :user_id, :integer
  end

  def down
    remove_column :service_requests, :user_id, :integer
  end
end
