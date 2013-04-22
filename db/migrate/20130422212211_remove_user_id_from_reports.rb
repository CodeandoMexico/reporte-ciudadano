class RemoveUserIdFromReports < ActiveRecord::Migration
  def up
    remove_column :reports, :user_id
  end

  def down
    add_column :reports, :user_id, :integer
    add_index :reports, :user_id
  end
end
