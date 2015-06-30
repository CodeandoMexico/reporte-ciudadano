require 'spec_helper'
require_relative '../../app/services/reports'

module Reports
  class TestSurveyReport
    attr_accessor :positive_overall_perception, :people_who_participated

    def initialize(attrs)
      @positive_overall_perception = attrs[:positive_overall_perception]
      @people_who_participated = attrs[:people_who_participated]
    end
  end

  class CisStore
  end

  class TestCisReport
    attr_accessor :positive_overall_perception, :negative_overall_perception,
      :people_who_participated, :created_at, :overall_areas

    def initialize(attrs)
      @positive_overall_perception = attrs[:positive_overall_perception]
      @negative_overall_perception = attrs[:negative_overall_perception]
      @created_at = attrs[:created_at]
      @overall_areas = attrs[:overall_areas]
    end

  end

  describe 'cis report for' do
    attr_reader :cis

    before do
      @cis = { id: 1, name: "Centro 1" }
    end

    it 'should respond to title' do
      cis_report = TestCisReport.new(positive_overall_perception: 40.0, negative_overall_perception: 60.0, respondents_count: 12, created_at: 1.day.ago)
      allow(CisStore).to receive(:last_report_for).with(1).and_return cis_report

      report = report_for(@cis, cis_report_store: CisStore)
      expect(report.title).to eq "Satisfacción general de servicios"
    end

    describe 'should respond to positive and negative overall' do
      example do
        cis_report = TestCisReport.new(positive_overall_perception: 40.0, negative_overall_perception: 60.0, respondents_count: 12)
        allow(CisStore).to receive(:last_report_for).with(1).and_return nil
        allow(CisStore).to receive(:create!).with(record_params(cis_id: 1, positive_overall_perception: 40.0, negative_overall_perception: 60.0, respondents_count: 12)).and_return cis_report

        survey_reports = [
          TestSurveyReport.new(positive_overall_perception: 60.0, people_who_participated: 4),
          TestSurveyReport.new(positive_overall_perception: 30.0, people_who_participated: 4),
          TestSurveyReport.new(positive_overall_perception: 30.0, people_who_participated: 4)
        ]
        report = report_for(@cis, survey_reports: survey_reports, cis_report_store: CisStore)
        expect(report.positive_overall_perception).to eq 40.0
        expect(report.negative_overall_perception).to eq 60.0
      end

      example do
        cis_report = TestCisReport.new(positive_overall_perception: 30.0, negative_overall_perception: 70.0, respondents_count: 10)
        allow(CisStore).to receive(:last_report_for).with(1).and_return nil
        allow(CisStore).to receive(:create!).with(record_params(cis_id: 1, positive_overall_perception: 30.0, negative_overall_perception: 70.0, respondents_count: 10)).and_return cis_report
        survey_reports = [
          TestSurveyReport.new(positive_overall_perception: nil, people_who_participated: 0),
          TestSurveyReport.new(positive_overall_perception: 30.0, people_who_participated: 10)
        ]
        report = report_for(@cis, survey_reports: survey_reports, cis_report_store: CisStore)
        expect(report.positive_overall_perception).to eq 30.0
        expect(report.negative_overall_perception).to eq 70.0
      end
    end

    describe 'should respond to areas overall' do
      it 'should respond with label for area: transparency and positive percentage' do
        cis_report = cis_report_with_areas(transparency: 55.0)
        allow(CisStore).to receive(:last_report_for).with(1).and_return cis_report

        report = report_for(@cis, cis_report_store: CisStore)
        expect(report.overall_areas).to include [:transparency, 55.0]
      end
    end

    def cis_report_with_areas(attrs)
      params = {
        positive_overall_perception: 50.0,
        negative_overall_perception: 50.0,
        respondents_count: 10,
        created_at: 1.day.ago,
        overall_areas: attrs
      }
      TestCisReport.new(params.merge(attrs))
    end

    def report_for(cis, survey_reports: :not_used, cis_report_store: :not_used)
      Reports.current_cis_report_for(cis, cis_report_store: cis_report_store, survey_reports: survey_reports, translator: I18n.method(:t))
    end

    def record_params(attrs)
      {
        cis_id: attrs[:cis_id],
        positive_overall_perception: attrs[:positive_overall_perception],
        negative_overall_perception: attrs[:negative_overall_perception],
        respondents_count: attrs[:respondents_count]
      }
    end
  end
end