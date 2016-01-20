class AddAreasResultsToServiceSurveyReport < ActiveRecord::Migration
  def up
    add_column :service_survey_reports, :areas_results, :text
  end

  def down
    remove_column :service_survey_reports, :areas_results
  end
end
