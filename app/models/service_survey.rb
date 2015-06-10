class ServiceSurvey < ActiveRecord::Base
  has_and_belongs_to_many :services, join_table: :services_service_surveys
  belongs_to :admin
  has_many :questions
  has_many :answers, class: SurveyAnswer, through: :questions, source: :survey_answers

  validates_presence_of :phase
  validate :complete_percentage_for_rating_questions

  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true

  scope :open, -> {
    where(open: true)
  }
  def services_names
    services.map(&:name).join(", ")
  end

  def admin_name
    admin.name
  end

  def questions_count
    questions.count
  end

  def has_been_answered_by?(user)
    return false if user.blank?
    answers.any? { |answer| answer.user_id == user.id }
  end

  private

  def complete_percentage_for_rating_questions
    value_questions = questions
      .select { |question| ['rating', 'binary'].include? question.answer_type }
      .reject { |question| question._destroy.present? }
    if value_questions.any? && value_questions.map(&:value).sum != 100
      errors.add(:questions, I18n.t("service_survey.errors.total_values", count: value_questions.map(&:value).sum))
    end
  end
end