class RemoveTitleAndPhaseFromServiceSurveyReports < ActiveRecord::Migration
  def up
    remove_column :service_survey_reports, :title
    remove_column :service_survey_reports, :phase
  end

  def down
    add_column :service_survey_reports, :title
    add_column :service_survey_reports, :phase
  end
end
