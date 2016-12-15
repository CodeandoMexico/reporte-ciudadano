class AddStatusToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :status, :integer, default: 1
  end
end
