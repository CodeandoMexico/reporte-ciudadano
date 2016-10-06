class AddOverallAreasToCisReports < ActiveRecord::Migration
  def change
    add_column :cis_reports, :overall_areas, :text
  end
end
