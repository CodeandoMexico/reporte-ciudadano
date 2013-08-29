class ChangeDefaultValueForStatusIdOnReports < ActiveRecord::Migration
  def up
    change_column_default :reports, :status_id, 1
  end

  def down
    change_column_default :reports, :status_id, nil
  end
end
