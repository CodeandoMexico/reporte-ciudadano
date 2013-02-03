class AddUserIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :user_id, :integer
    add_index :reports, :user_id
  end
end
