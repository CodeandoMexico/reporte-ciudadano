class ChangeDescriptionTypeServiceRequests < ActiveRecord::Migration
  def change
    change_column :service_requests, :description, :text
  end
end
