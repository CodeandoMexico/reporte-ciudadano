class SurveyAnswer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  scope :validated, -> {
    where(ignored: false)
  }
  scope :rating_and_binary, -> {
    SurveyAnswer.joins(:question).where("questions.answer_type" => ['rating','binary']).includes(:service_survey)
  }
end
