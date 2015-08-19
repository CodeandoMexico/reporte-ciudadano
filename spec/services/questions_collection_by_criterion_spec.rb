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
        (double 'question', text: "¿Question?", criterion: "performance", answer_type: "open"),
        (double 'question', text: "¿Question?", criterion: "quality_service", answer_type: "list"),
        (double 'question', text: "¿Question?", criterion: "infrastructure", answer_type: "binary"),
        (double 'question', text: "¿Question?", criterion: "public_servant", answer_type: "binary"),
        (double 'question', text: "¿Question?", criterion: "accessibility", answer_type: "rating")
      ]
      expect(questions_collection(questions_records)).to eq(
        transparency: [{ text: "¿Question?", answer_type: 'binary', selected_answer: 'Respuesta Sí/No'}],
        performance: [{ text: "¿Question?", answer_type: 'open', selected_answer: 'Respuesta abierta'}],
        accessibility: [{ text: "¿Question?", answer_type: 'rating', selected_answer: 'Respuesta rango'}],
        infrastructure: [{ text: "¿Question?", answer_type: 'binary', selected_answer: 'Respuesta Sí/No'}],
        quality_service: [{ text: "¿Question?", answer_type: 'list', selected_answer: 'Respuesta personalizada'}],
        public_servant: [{ text: "¿Question?", answer_type: 'binary', selected_answer: 'Respuesta Sí/No'}]
      )
    end

    def questions_collection(records)
      ServiceSurveys.questions_collection_by_criterion(records, translator: I18n.method(:t))
    end
  end
end