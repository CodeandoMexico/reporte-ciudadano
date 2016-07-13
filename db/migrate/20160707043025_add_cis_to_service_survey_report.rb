class AddCisToServiceSurveyReport < ActiveRecord::Migration
  def up
    add_column :service_survey_reports, :cis_id, :integer
  end

  def down
    remove_column :service_survey_reports, :service_id
  end
end
