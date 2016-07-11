class CreateReportedQuestions < ActiveRecord::Migration
  def change
    create_table :reported_questions do |t|
      t.integer  :service_survey_report_id, default: 0
      t.integer  :service_survey_id, default: 0
      t.integer  :service_id, default: 0
      t.integer  :cis_id, default: 0
      t.integer  :question_id, default: 0
      t.string   :question_text, default: ""
      t.string   :question_criterion, default: ""
      t.string   :question_type, default: ""
      t.string   :answer_text, default: ""
      t.string   :answer_rating_range, default: ""
      t.boolean  :question_is_optional, default: false
      t.boolean  :has_ignored_questions, default: false
      t.decimal  :value_in_survey, default: 0
      t.decimal  :result_reported, default: 0
    end
  end
end
