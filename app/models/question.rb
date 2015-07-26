class Question < ActiveRecord::Base
  belongs_to :service_survey
  serialize :answers, Array
  has_many :survey_answers

  validates :answer_type, inclusion: { in: %w(binary rating open list) }
  validates_presence_of :value, if: :answer_type_rating?
  validates_presence_of :answer_rating_range, if: :answer_type_rating?
  validates_numericality_of :value, if: :answer_type_rating?

  scope :rating_and_binary_questions, ->{
    where(answer_type: ['rating','binary'])
  }

  default_scope { order(id: :asc) }

  def has_open_answer?
    answer_type == 'open'
  end

  def answers_set
    answers.reject(&:empty?)
  end

  def survey_answer_by_user(user_id)
    survey_answers.where(user_id: user_id).first
  end

  private

  def answer_type_rating?
    answer_type == 'rating'
  end
end
