class SurveyAnswer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  scope :validated, -> {
    where(ignored: false)
  }
end
