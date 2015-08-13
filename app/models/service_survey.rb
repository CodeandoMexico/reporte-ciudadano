class ServiceSurvey < ActiveRecord::Base
  has_and_belongs_to_many :services, join_table: :services_service_surveys, counter_cache: true
  belongs_to :admin
  has_many :questions
  has_many :answers, class: SurveyAnswer, through: :questions, source: :survey_answers
  has_many :reports, class: ServiceSurveyReport
  has_many :users, through: :answers, source: :user

  validates_presence_of :phase
  validate :value_for_rating_questions

  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true

  scope :open, -> {
    where(open: true)
  }

  def rating_and_binary_answers
    self.answers.validated.where(
        :question_id =>
          Question.rating_and_binary_questions
    )
  end

  def services_names
    services.map(&:name).join(", ")
  end

  def admin_name
    admin.name
  end

  def questions_count
    questions.count
  end

  def sorted_questions
    questions.order(id: :asc)
  end

  def has_been_answered_by?(user, cis_id)
    return false if user.blank? || cis_id.blank?
    answers.where(user_id: user.id, cis_id:cis_id).any?
  end

  def answers_by(user_id)
    answers.where(user_id: user_id)
  end

  def answers_are_being_ignored_for(user_id)
    answers_by(user_id).any?(&:ignored)
  end

  def status
    if open?
      :open
    else
      :close
    end
  end

  def last_report
    reports.order(created_at: :asc).last
  end

  def respondents
    users.uniq
  end

  private

  def value_for_rating_questions
    if value_questions.any? && (value_questions.map(&:value).include?(0.0) || value_questions.map(&:value).any?(&:blank?))
      errors.add(:questions, I18n.t("service_survey.errors.presence_of_value"))
    else
      complete_percentage_for_rating_questions
    end
  end

  def value_questions
    questions
      .select { |question| ['rating', 'binary'].include? question.answer_type }
      .reject { |question| question._destroy.present? }
  end

  def complete_percentage_for_rating_questions
    if value_questions.any? && value_questions.map(&:value).sum != 100
      errors.add(:questions, I18n.t("service_survey.errors.total_values", count: value_questions.map(&:value).sum))
    end
  end
end