class CreateSurveyAnswers < ActiveRecord::Migration
  def change
    create_table :survey_answers do |t|
      t.string :text
      t.references :question, index: true
      t.decimal :score
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :survey_answers, :questions
    add_foreign_key :survey_answers, :users
  end
end
