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
    include ActiveModel::Model

    def initialize(attrs)
      @title = attrs[:title]
      @phase = attrs[:phase]
      @service_ids = attrs[:service_ids] || []
      @questions_hash = (attrs[:questions_attributes]) || {}
    end

    def to_record_params
      {
        title: title,
        phase: phase,
        service_ids: service_ids,
        questions_attributes: questions
      }
    end

    private

    attr_reader :questions_hash, :title, :phase, :service_ids

    def questions
      questions_hash.each do |key, question_params|
        questions_hash[key] = Question.new(question_params).to_record_params
      end
    end
  end

  class Question
    def initialize(attrs)
      @criterion = attrs["criterion"]
      @text = attrs["text"]
      @answer_type = attrs["answer_type"]
      @answer_rating_range = attrs["answer_rating_range"]
      @value = attrs["value"]
    end

    def to_record_params
      {
        criterion: criterion,
        text: text,
        answer_type: answer_type,
        answers: answers,
        value: value,
        answer_rating_range: answer_rating_range_for_answer_type
      }
    end

    private

    attr_reader :answer_type, :criterion, :text, :answer_rating_range, :value

    def answers
      case answer_type
      when "binary"
        ["Sí", "No"]
      when "rating"
        if answer_rating_range == "good"
          ["Muy bueno", "Bueno", "Regular", "Malo", "Muy malo"]
        elsif answer_rating_range == "satisfied"
          ["Muy satisfecho", "Satisfecho", "Regular", "Poco satisfecho", "Nada satisfecho"]
        end
      else
        []
      end
    end

    def answer_rating_range_for_answer_type
      if answer_type == "rating"
        answer_rating_range
      end
    end
  end
end