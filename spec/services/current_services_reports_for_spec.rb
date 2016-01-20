require 'spec_helper'
require_relative '../../app/services/reports'
require_relative '../../app/services/service_surveys'

module Reports
  class ServiceReportStore
  end

  class TestServiceReport
    attr_accessor :positive_overall_perception, :negative_overall_perception,
      :people_who_participated, :created_at, :overall_areas

    def initialize(attrs)
      @positive_overall_perception = attrs[:positive_overall_perception]
      @negative_overall_perception = attrs[:negative_overall_perception]
      @created_at = attrs[:created_at]
      @overall_areas = attrs[:overall_areas]
    end
  end

  class TestService
    attr_accessor :last_report, :id, :last_survey_reports
    def initialize(attrs)
      @last_report = attrs[:last_report]
      @last_survey_reports = attrs[:last_survey_reports]
      @id = attrs[:id]
    end
  end

  describe 'service report for' do
    example do
      service_report = TestServiceReport.new(positive_overall_perception: 40.0, negative_overall_perception: 60.0, respondents_count: 12, overall_areas: overall_areas_empty, created_at: 1.day.ago)
      service = TestService.new(id: 'service-1', last_report: service_report, last_survey_reports: [])

      report = service_report_for(service, services_report_store: ServiceReportStore)
      expect(report.positive_overall_perception).to eq 40.0
      expect(report.negative_overall_perception).to eq 60.0
    end

    def overall_areas_empty
      ServiceSurveys.criterion_options_available.map do |area|
        [area, 0.0]
      end.to_h
    end

    def service_report_for(service_record, services_report_store: :not_used)
      Reports.current_service_report_for(service_record, services_report_store: services_report_store)
    end
  end
end