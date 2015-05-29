class Question < ActiveRecord::Base
  belongs_to :service_survey
  serialize :answers, Array

  validates_presence_of :answer_type, :text
  validates_presence_of :value, if: :answer_type_rating?
  validates_presence_of :answer_rating_range, if: :answer_type_rating?
  validates_numericality_of :value, if: :answer_type_rating?

  def has_binary_answer?
    answer_type == 'binary'
  end

  private

  def answer_type_rating?
    answer_type == 'rating'
  end
end
