require 'spec_helper'
require_relative '../../app/services/service_surveys'

module ServicesSurveys
  class TestServiceSurvey
    attr_accessor :title, :questions_count, :questions, :id

    def initialize(attrs)
      @id = attrs[:id]
      @title = attrs[:title]
      @questions = attrs[:questions]
      @questions_count = attrs[:questions_count]
    end
  end

  class TestQuestionForm
    attr_accessor :answers, :id, :answer_type, :value, :criterion, :text, :answer_rating_range

    def initialize(attrs)
      @answers = attrs[:answers] || []
      @id = attrs[:id]
      @answer_type = attrs[:answer_type] || "open"
      @value = attrs[:value]
      @answer_rating_range = attrs[:answer_rating_range]
    end
  end

  describe 'form_for_answers' do
    it 'should respond to questions count' do
      service_survey = TestServiceSurvey.new(questions_count: 5)
      form = form_for_answers(service_survey)
      expect(form.questions_count).to eq 5
    end

    it 'should respond to id' do
      service_survey = TestServiceSurvey.new({})
      service_survey.id = 1
      form = form_for_answers(service_survey)
      expect(form.id).to eq 1
    end

    it 'should respond to questions' do
      service_survey = TestServiceSurvey.new(questions: [ TestQuestionForm.new({}), TestQuestionForm.new({}) ])
      form = form_for_answers(service_survey)
      expect(form.questions.size).to eq 2
    end

    describe 'should respond answers to every question' do
      example do
        question = TestQuestionForm.new(answers: ["Sí", "No"], value: 20.0, answer_type: "binary")
        service_survey = TestServiceSurvey.new(questions: [ question ])
        first_answer = answers_for_first_question(service_survey).first
        expect(first_answer.text).to eq "Sí"
        expect(first_answer.score).to eq 20.0
      end

      example do
        question = TestQuestionForm.new(answers: ["Sí", "No"], value: 20.0, answer_type: "binary")
        service_survey = TestServiceSurvey.new(questions: [ question ])
        second_answer = answers_for_first_question(service_survey).second
        expect(second_answer.text).to eq "No"
        expect(second_answer.score).to eq 0.0
      end

      example do
        question = TestQuestionForm.new(answers: ["Muy satisfecho", "Satisfecho", "Regular", "Poco satisfecho", "Nada satisfecho"], value: 20.0, answer_type: "rating", answer_rating_range: :satisfied)
        service_survey = TestServiceSurvey.new(questions: [ question ])
        first_answer = answers_for_first_question(service_survey).first
        expect(first_answer .text).to eq "Muy satisfecho"
        expect(first_answer .score).to eq 20.0
      end

      example do
        question = TestQuestionForm.new(answers: ["Muy satisfecho", "Satisfecho", "Regular", "Poco satisfecho", "Nada satisfecho"], value: 20.0, answer_type: "rating", answer_rating_range: :satisfied)
        service_survey = TestServiceSurvey.new(questions: [ question ])
        last_answer = answers_for_first_question(service_survey).last
        expect(last_answer.text).to eq "Nada satisfecho"
        expect(last_answer.score).to eq 0.0
      end

      example do
        question = TestQuestionForm.new(answers: ["Muy bueno", "Bueno", "Regular", "Malo", "Muy malo"], value: 50.0, answer_type: "rating", answer_rating_range: :satisfied)
        service_survey = TestServiceSurvey.new(questions: [ question ])
        first_answer = answers_for_first_question(service_survey).first
        expect(first_answer .text).to eq "Muy bueno"
        expect(first_answer .score).to eq 50.0
      end

      example do
        question = TestQuestionForm.new(answers: ["Muy bueno", "Bueno", "Regular", "Malo", "Muy malo"], value: 50.0, answer_type: "rating", answer_rating_range: :satisfied)
        service_survey = TestServiceSurvey.new(questions: [ question ])
        last_answer = answers_for_first_question(service_survey).last
        expect(last_answer.text).to eq "Muy malo"
        expect(last_answer.score).to eq 0.0
      end

      example do
        question = TestQuestionForm.new(answers: ["Muy satisfecho", "Satisfecho", "Regular", "Poco satisfecho", "Nada satisfecho"], value: 20.0, answer_type: "rating", answer_rating_range: :satisfied)
        service_survey = TestServiceSurvey.new(questions: [ question ])
        neutral_answer = answers_for_first_question(service_survey)[2]
        expect(neutral_answer.text).to eq "Regular"
        expect(neutral_answer.score).to eq 10.0
      end

      example do
        question = TestQuestionForm.new(answers: ["Custom answer", "Custom answer 2", "", "", ""], value: 20.0, answer_type: "list")
        service_survey = TestServiceSurvey.new(questions: [ question ])
        answers = answers_for_first_question(service_survey)
        expect(answers.size).to eq 2
        expect(answers.first.text).to eq "Custom answer"
        expect(answers.first.score).to eq nil
      end

      example do
        question = TestQuestionForm.new(answers: [], value: 20.0, answer_type: "open")
        service_survey = TestServiceSurvey.new(questions: [ question ])
        answers = answers_for_first_question(service_survey)
        expect(answers).to be_empty
      end
    end

    def answers_for_first_question(survey)
      ServiceSurveys.form_for_answers(survey).questions.first.answers
    end

    def form_for_answers(survey)
      ServiceSurveys.form_for_answers(survey)
    end
  end
end