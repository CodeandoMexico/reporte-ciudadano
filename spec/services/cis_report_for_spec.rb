require 'spec_helper'
require_relative '../../app/services/reports'

module Reports
  class TestSurveyReport
    attr_accessor :positive_overall_perception

    def initialize(attrs)
      @positive_overall_perception = attrs[:positive_overall_perception]
    end
  end

  describe 'cis report for' do
    attr_reader :cis

    before do
      @cis = { id: 1, name: "Centro 1" }
    end

    it 'should respond to title' do
      report = report_for(@cis)
      expect(report.title).to eq "Satisfacción general de servicios"
    end

    describe 'should respond to positive and negative overall' do
      example do
        survey_reports = [
          TestSurveyReport.new(positive_overall_perception: 60.0),
          TestSurveyReport.new(positive_overall_perception: 30.0),
          TestSurveyReport.new(positive_overall_perception: 30.0)
        ]
        report = report_for(@cis, survey_reports: survey_reports)
        expect(report.positive_overall).to eq 40.0
        expect(report.negative_overall).to eq 60.0
      end

      example do
        survey_reports = [
          TestSurveyReport.new(positive_overall_perception: nil),
          TestSurveyReport.new(positive_overall_perception: 30.0)
        ]
        report = report_for(@cis, survey_reports: survey_reports)
        expect(report.positive_overall).to eq 30.0
        expect(report.negative_overall).to eq 70.0
      end
    end

    def report_for(cis, survey_reports: :not_used, cis_report_store: :not_used)
      Reports.cis_report_for(cis, survey_reports: survey_reports, translator: I18n.method(:t))
    end
  end
end