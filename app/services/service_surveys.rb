module ServiceSurveys
  def self.phase_options
    [:start, :middle, :end]
  end

  def self.criterion_options
    I18n.t("question_criterion_options").to_a.map(&:reverse)
  end

  def self.answer_type_options
    I18n.t("question_answer_type_options").to_a.map(&:reverse)
  end

  def self.generate_hash_for_record(survey_params)
    ServiceSurvey.new(survey_params).to_record_params
  end

  private

  class ServiceSurvey
    def initialize(attrs)
      @title = attrs[:title]
      @phase = attrs[:phase]
      @service_ids = attrs[:service_ids] || []
      @questions_array = Array.wrap(attrs[:questions]) || []
    end

    def to_record_params
      {
        title: title,
        phase: phase,
        service_ids: service_ids,
        questions_attributes: questions.map(&:to_record_params)
      }
    end

    private

    attr_reader :questions_array, :title, :phase, :service_ids

    def questions
      questions_array.map { |question_params| Question.new(question_params) }
    end
  end

  class Question
    def initialize(attrs)
      @criterion = attrs["criterion"]
      @text = attrs["text"]
      @answer_type = attrs["answer_type"]
    end

    def to_record_params
      {
        criterion: criterion,
        text: text,
        answer_type: answer_type,
        answers: answers
      }
    end

    private

    attr_reader :answer_type, :criterion, :text

    def answers
      case answer_type
      when "binary"
        ["Sí", "No"]
      else
        []
      end
    end
  end
end