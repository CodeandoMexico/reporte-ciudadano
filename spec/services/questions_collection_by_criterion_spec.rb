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
        (double 'question', text: "¿Question?", criterion: "transparency"),
        (double 'question', text: "¿Question?", criterion: "transparency"),
        (double 'question', text: "¿Question?", criterion: "performance"),
        (double 'question', text: "¿Question?", criterion: "quality_service"),
        (double 'question', text: "¿Question?", criterion: "infrastructure"),
        (double 'question', text: "¿Question?", criterion: "accessibility")
      ]
      expect(questions_collection(questions_records)).to eq(
        transparency: ["¿Question?"],
        performance: ["¿Question?"],
        accessibility: ["¿Question?"],
        infrastructure: ["¿Question?"],
        quality_service: ["¿Question?"]
      )
    end

    def questions_collection(records)
      ServiceSurveys.questions_collection_by_criterion(records)
    end
  end
end