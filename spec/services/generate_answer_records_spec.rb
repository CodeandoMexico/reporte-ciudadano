require 'spec_helper'
require_relative '../../app/services/service_surveys'

module ServicesSurveys
  class TestServiceSurvey
    attr_accessor :title, :questions_count, :questions

    def initialize(attrs)
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

  describe 'generate answer records' do
    it 'should return the binary answers hash with value' do
      user = double 'user', id: 'user-id'
      answer_params = {
        "question_id"=>"question-id",
        "text"=>"No",
        "question_answer_type"=>"binary",
        "question_value"=>"20.0"
      }
      first_answer = generate_answer_records([answer_params], "user-id").first
      expect(first_answer).to include(text: "No", question_id: "question-id", score: 0.0, user_id: 'user-id')
    end

    it 'should return the binary answers hash with value' do
      user = double 'user', id: 'user-id'
      answer_params = {
        "question_id"=>"question-id",
        "text"=>"Sí",
        "question_answer_type"=>"binary",
        "question_value"=>"20.0"
      }
      first_answer = generate_answer_records([answer_params], "user-id").first
      expect(first_answer).to include(text: "Sí", question_id: "question-id", score: 20.0, user_id: 'user-id')
    end

    it 'should return the rating answers hash with value' do
      user = double 'user', id: 'user-id'
      answer_params = {
        "question_id"=>"question-id",
        "text"=>"Muy bueno",
        "question_answer_type"=>"rating",
        "question_value"=>"30.0"
      }
      first_answer = generate_answer_records([answer_params], "user-id").first
      expect(first_answer).to include(text: "Muy bueno", question_id: "question-id", score: 30.0, user_id: 'user-id')
    end

    it 'should return the rating answers hash with value' do
      user = double 'user', id: 'user-id'
      answer_params = {
        "question_id"=>"question-id",
        "text"=>"Regular",
        "question_answer_type"=>"rating",
        "question_value"=>"30.0"
      }
      first_answer = generate_answer_records([answer_params], "user-id").first
      expect(first_answer).to include(text: "Regular", question_id: "question-id", score: 15.0, user_id: 'user-id')
    end

    it 'should return the open answer hash with no value' do
      user = double 'user', id: 'user-id'
      answer_params = {
        "question_id"=>"question-id",
        "text"=>"Custom text for answer...",
        "question_answer_type"=>"open",
        "question_value"=>"30.0"
      }
      first_answer = generate_answer_records([answer_params], "user-id").first
      expect(first_answer).to include(text: "Custom text for answer...", question_id: "question-id", score: nil, user_id: 'user-id')
    end

    it 'should return the list answer hash with no value' do
      user = double 'user', id: 'user-id'
      answer_params = {
        "question_id"=>"question-id",
        "text"=>"Custom answer 1",
        "question_answer_type"=>"list",
        "question_value"=>"30.0"
      }
      first_answer = generate_answer_records([answer_params], "user-id").first
      expect(first_answer).to include(text: "Custom answer 1", question_id: "question-id", score: nil, user_id: 'user-id')
    end

    def generate_answer_records(params, user_id)
      ServiceSurveys.generate_answer_records(params, user_id)
    end
  end
end