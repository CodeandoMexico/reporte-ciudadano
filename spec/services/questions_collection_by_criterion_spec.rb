require 'spec_helper'
require_relative '../../app/services/service_surveys'

module ServicesSurveys

  class TestQuestion
    attr_reader :text, :criterion

    def initialize(attrs)
      @text = attrs[:text]
      @criterion = attrs[:criterion]
    end
  end

  describe 'questions_collection_by_criterion' do
    it 'returns a hash with questions by criterion' do
      questions_records = [
        (double 'question', text: "¿Question?", criterion: "transparency", answer_type: "binary"),
        (double 'question', text: "¿Question?", criterion: "transparency", answer_type: "binary"),
        (double 'question', text: "¿Question?", criterion: "performance", answer_type: "binary"),
        (double 'question', text: "¿Question?", criterion: "quality_service", answer_type: "binary"),
        (double 'question', text: "¿Question?", criterion: "infrastructure", answer_type: "binary"),
        (double 'question', text: "¿Question?", criterion: "accessibility", answer_type: "binary")
      ]
      expect(questions_collection(questions_records)).to eq(
        transparency: [{ text: "¿Question?", answer_type: 'binary'}],
        performance: [{ text: "¿Question?", answer_type: 'binary'}],
        accessibility: [{ text: "¿Question?", answer_type: 'binary'}],
        infrastructure: [{ text: "¿Question?", answer_type: 'binary'}],
        quality_service: [{ text: "¿Question?", answer_type: 'binary'}]
      )
    end

    def questions_collection(records)
      ServiceSurveys.questions_collection_by_criterion(records)
    end
  end
end