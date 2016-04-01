class AddAnswersToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :answers, :text
  end
end
