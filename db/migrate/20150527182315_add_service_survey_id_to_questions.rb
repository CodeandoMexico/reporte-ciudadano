class AddServiceSurveyIdToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :service_survey, index: true
    add_foreign_key :questions, :service_surveys
  end
end
