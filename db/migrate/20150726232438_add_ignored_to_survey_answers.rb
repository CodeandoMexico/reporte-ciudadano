class AddIgnoredToSurveyAnswers < ActiveRecord::Migration
  def change
    add_column :survey_answers, :ignored, :boolean, default: false
  end
end
