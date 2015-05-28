class AddAnswerRatingRangeToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :answer_rating_range, :string
  end
end
