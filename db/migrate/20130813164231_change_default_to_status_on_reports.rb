class ChangeDefaultToStatusOnReports < ActiveRecord::Migration
  def up
    change_column_default :reports, :status, :open
  end

  def down
    change_column_default :reports, :status, "1"
  end
end
