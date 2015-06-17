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
      collection[criterion] = question_records
        .select { |question| question.criterion == criterion.to_s }
        .map { |question| { text: question.text, answer_type: question.answer_type } }
    end
    collection
  end

  def self.form_for_answers(service_survey_record)
    ServiceSurveyForm.new(service_survey_record)
  end

  def self.generate_answer_records(answer_params, user_id)
    answer_params.map { |answer| AnswerForm.new(answer.merge(user_id: user_id).symbolize_keys).to_record_params }
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
      if ["rating", "binary"].include? answer_type
        value
      end
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

  class ServiceSurveyForm
    attr_reader :id, :title, :questions_count

    def initialize(survey_record)
      @id = survey_record.id
      @title = survey_record.title
      @questions_count = survey_record.questions_count
      @questions_records = survey_record.questions
    end

    def questions
      questions_records.map { |question| QuestionForm.new(question) }
    end

    private
    attr_reader :questions_records
  end

  class QuestionForm
    attr_reader :criterion, :text, :id, :value, :answer_type

    def initialize(question_record)
      @answers_text = question_record.answers.reject(&:empty?)
      @value = question_record.value
      @id = question_record.id
      @answer_type = question_record.answer_type
      @criterion = question_record.criterion
      @text = question_record.text
    end

    def has_open_answer?
      answer_type == "open"
    end

    def answers
      answers_text.map { |text| AnswerForm.new(text: text, question_value: value, question_id: id, question_answer_type: answer_type) }
    end

    private

    attr_reader :answers_text
  end

  class AnswerForm
    attr_reader :text, :question_id, :question_value, :question_answer_type

    def initialize(attrs)
      @text = attrs[:text]
      @question_value = attrs[:question_value] || 0.0
      @question_id = attrs[:question_id]
      @question_answer_type = attrs[:question_answer_type]
      @user_id = attrs[:user_id] || nil
    end

    def score
      if [:binary, :rating].include? question_answer_type.to_sym
        question_value.to_f * self.send("#{question_answer_type}_score")
      end
    end

    def to_record_params
      {
        text: text,
        question_id: question_id,
        score: score,
        user_id: user_id
      }
    end

    private
    attr_reader :user_id

    def binary_score
      { "Sí" => 1.0, "No" => 0.0 }.fetch(text)
    end

    def rating_score
      { "Muy satisfecho" => 1.0, "Satisfecho" => 0.75, "Regular" => 0.5, "Poco satisfecho" => 0.25, "Nada satisfecho" => 0.0,
        "Muy bueno" => 1.0, "Bueno" => 0.75, "Malo" => 0.25, "Muy malo" => 0.0 }.fetch(text)
    end
  end
end