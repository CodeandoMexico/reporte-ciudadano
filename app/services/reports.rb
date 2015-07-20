module Reports
  def self.current_cis_report_for(cis, cis_report_store:, survey_reports:, translator:)
    last_report = build_report(
      cis_report_store.last_report_for(cis[:id]),
      survey_reports,
      cis_report_store,
      cis_id: cis[:id]
    )

    CisReportView.new(
      title: translator.call("cis_reports.title"),
      cis_data: cis,
      survey_reports: survey_reports,
      report: last_report)
  end

  def self.current_service_report_for(service, services_report_store:)
    build_report(service.last_report, service.last_survey_reports, services_report_store, service_id: service.id)
  end

  private

  def self.build_report(last_report, survey_reports, report_store, params)
    return last_report if (last_report.present? && last_report.created_at > 3.days.ago)

    generator = ReportGenerator.new(survey_reports: survey_reports)
    report_store.create!(generator.to_record_params.merge(params))
  end

  class ReportGenerator
    def initialize(attrs)
      @survey_reports = attrs[:survey_reports] || []
    end

    def positive_overall_perception
      return 0 if survey_reports_to_quantify.empty?
      survey_reports_to_quantify.sum / (survey_reports_to_quantify.count * 1.0)
    end

    def negative_overall_perception
      return 0 if survey_reports_to_quantify.empty?
      100.0 - positive_overall_perception
    end

    def overall_areas
      overall_areas_hash = overall_areas_empty
      return overall_areas_hash if survey_reports_to_quantify.empty?

      overall_areas_hash.each do |key, value|
        overall_areas_hash[key] = total_by_area(survey_reports.map(&:areas_results), key, value) / survey_reports.count
      end

      overall_areas_hash
    end

    def total_by_area(areas_hash_array, key, acc)
      return acc if areas_hash_array.empty?
      next_value = areas_hash_array.shift[key]
      total_by_area(areas_hash_array, key, acc + next_value)
    end

    def to_record_params
      {
        positive_overall_perception: positive_overall_perception,
        negative_overall_perception: negative_overall_perception,
        respondents_count: respondents_count,
        overall_areas: overall_areas
      }
    end

    def respondents_count
      survey_reports.map(&:people_who_participated).sum
    end

    private
    attr_reader :survey_reports, :cis_id

    def survey_reports_to_quantify
      survey_reports
        .map(&:positive_overall_perception)
        .select(&:present?)
    end

    def overall_areas_empty
      ServiceSurveys.criterion_options_available.map do |area|
        [area, 0.0]
      end.to_h
    end
  end

  class CisReportView
    attr_reader :title, :positive_overall_perception, :negative_overall_perception

    def initialize(attrs)
      @title = attrs[:title]
      @positive_overall_perception = attrs[:report].positive_overall_perception
      @negative_overall_perception = attrs[:report].negative_overall_perception
      @overall_by_areas = attrs[:report].overall_areas
    end

    def overall_areas
      overall_by_areas.to_a
    end

    private
    attr_reader :overall_by_areas
  end
end