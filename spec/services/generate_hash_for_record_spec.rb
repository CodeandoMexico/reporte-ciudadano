require 'spec_helper'
require_relative '../../app/services/service_surveys'

module ServicesSurveys
  describe 'generate hash for record' do
    it 'when the answer type is binary' do
      params = survey_params_with_question(answer_type: "binary")
      question_hash = first_question_hash(params)
      expect(question_hash[:answers]).to eq ["Sí", "No"]
      expect(question_hash.has_key?(:value)).not_to be
    end

    def survey_params_with_question(params)
      {
        title: "title",
        phase: "start",
        text: "question ?",
        questions: [ { criterion: "criterion" }.merge(params) ]
      }
    end

    def first_question_hash(params)
      ServiceSurveys.generate_hash_for_record(params)[:questions].first
    end
  end
end