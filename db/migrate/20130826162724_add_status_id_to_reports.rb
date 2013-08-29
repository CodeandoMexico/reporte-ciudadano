class AddStatusIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :status_id, :integer
    add_index :reports, :status_id
  end
end
