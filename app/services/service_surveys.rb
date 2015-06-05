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

  def self.questions_collection_by_criterion(question_records)
    collection = {}
    criterion_options_available.each do |criterion|
      collection[criterion] = question_records.select { |question| question.criterion == criterion.to_s }.map(&:text).uniq
    end
    collection
  end

  private

  def self.criterion_options_available
    I18n.t("question_criterion_options").keys
  end

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
      @_destroy = attrs["_destroy"]
      @id = attrs["id"]
      @custom_answers = attrs["answers"] || []
    end

    def to_record_params
      {
        criterion: criterion,
        text: text,
        answer_type: answer_type,
        answers: answers,
        value: value_for_answer_type,
        answer_rating_range: answer_rating_range_for_answer_type
      }.merge(destroy_question_param)
    end

    private

    attr_reader :answer_type, :criterion, :text, :answer_rating_range, :value, :_destroy, :id, :custom_answers

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
      when "list"
        custom_answers
      else
        []
      end
    end

    def value_for_answer_type
      return nil if answer_type != "rating"
      value
    end

    def answer_rating_range_for_answer_type
      if answer_type == "rating"
        answer_rating_range
      end
    end

    def destroy_question_param
      return {} unless _destroy && id
      {
        id: id,
        _destroy: _destroy
      }
    end
  end
end