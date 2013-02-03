class AddStatusToReports < ActiveRecord::Migration
  def change
    add_column :reports, :status, :integer, default: 1
  end
end
