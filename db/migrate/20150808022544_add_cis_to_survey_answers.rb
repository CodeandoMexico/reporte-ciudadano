class AddCisToSurveyAnswers < ActiveRecord::Migration

  def up
    add_column :survey_answers, :cis_id, :integer, default: -1
  end

  def down
    remove_column :survey_answers, :cis_id
  end

end