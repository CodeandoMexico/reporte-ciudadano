class ServiceSurvey < ActiveRecord::Base
  has_and_belongs_to_many :services, join_table: :services_service_surveys
  belongs_to :admin
  has_many :questions

  validates_presence_of :phase
  validate :complete_percentage_for_rating_questions

  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true

  def services_names
    services.map(&:name).join(", ")
  end

  def admin_name
    admin.name
  end

  def questions_count
    questions.count
  end

  private

  def complete_percentage_for_rating_questions
    rating_questions = questions.select { |question| question.answer_type == 'rating' }
    if rating_questions.any? && rating_questions.map(&:value).sum != 100
      errors.add(:questions, I18n.t("service_survey.errors.total_values", count: rating_questions.map(&:value).sum))
    end
  end
end