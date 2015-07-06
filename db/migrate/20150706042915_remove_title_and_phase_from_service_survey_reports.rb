class RemoveTitleAndPhaseFromServiceSurveyReports < ActiveRecord::Migration
  def change
    remove_column :service_survey_reports, :title
    remove_column :service_survey_reports, :phase
  end
end
