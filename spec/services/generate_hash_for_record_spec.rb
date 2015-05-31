require 'spec_helper'
require_relative '../../app/services/service_surveys'

module ServicesSurveys
  describe 'generate hash for record' do
    it 'when the answer type is binary' do
      params = survey_params_with_question("answer_type" => "binary", "answer_rating_range" => "good")
      question_hash = first_question_hash(params)
      expect(question_hash[:answers]).to eq ["Sí", "No"]
      expect(question_hash[:value]).to eq nil
      expect(question_hash[:answer_rating_range]).to eq nil
    end

    describe 'when the answer type is rating' do
      example do
        params = survey_params_with_question("answer_type" => "rating", "answer_rating_range" => "good", "value" => 10)
        question_hash = first_question_hash(params)
        expect(question_hash[:answers]).to eq ["Muy bueno", "Bueno", "Regular", "Malo", "Muy malo"]
        expect(question_hash[:value]).to eq 10
        expect(question_hash[:answer_rating_range]).to eq "good"
      end

      example do
        params = survey_params_with_question("answer_type" => "rating", "answer_rating_range" => "satisfied", "value" => 10)
        question_hash = first_question_hash(params)
        expect(question_hash[:answers]).to eq ["Muy satisfecho", "Satisfecho", "Regular", "Poco satisfecho", "Nada satisfecho"]
        expect(question_hash[:value]).to eq 10
        expect(question_hash[:answer_rating_range]).to eq "satisfied"
      end
    end

    it 'when the answer type is open' do
      params = survey_params_with_question("answer_type" => "open", "answer_rating_range" => "good")
      question_hash = first_question_hash(params)
      expect(question_hash[:answers]).to eq []
      expect(question_hash[:value]).to eq nil
      expect(question_hash[:answer_rating_range]).to eq nil
    end

    def survey_params_with_question(params)
      {
        title: "Un título",
        phase: "Al inicio",
        text: "pregunta ?",
        questions_attributes: { "123" => { "criterion" => "transparency" }.merge(params) }
      }
    end

    def first_question_hash(params)
      ServiceSurveys.generate_hash_for_record(params)[:questions_attributes]["123"]
    end
  end
end