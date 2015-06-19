class CreateServiceSurveyReports < ActiveRecord::Migration
  def change
    create_table :service_survey_reports do |t|
      t.belongs_to :service_survey, index: true
      t.float :positive_overall_perception, null:false, default: 0
      t.float :negative_overall_perception, null:false, default: 0
      t.integer :people_who_participated, null: false, default:0
      t.timestamps null: false
    end
  end
end
