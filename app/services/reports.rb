module Reports
  def self.current_cis_report_for(cis, cis_report_store:, survey_reports:, translator:)
    last_report = cis_report_store.last_report_for(cis[:id])

    if last_report.blank? || last_report.created_at < 3.days.ago
      generator = CisReportGenerator.new(cis_data: cis, survey_reports: survey_reports, )
      last_report = cis_report_store.create!(generator.to_record_params)
    end

    CisReportView.new(
      title: translator.call("cis_reports.title"),
      cis_data: cis,
      survey_reports: survey_reports,
      report: last_report)
  end

  private

  class CisReportGenerator
    def initialize(attrs)
      @cis_id = attrs[:cis_data][:id]
      @survey_reports = attrs[:survey_reports]
      @report = attrs[:report] || :no_report
    end

    def positive_overall_perception
      return 0 if survey_reports_to_quantify.empty?
      survey_reports_to_quantify.sum / (survey_reports_to_quantify.count * 1.0)
    end

    def negative_overall_perception
      return 0 if survey_reports_to_quantify.empty?
      100.0 - positive_overall_perception
    end

    def to_record_params
      {
        cis_id: cis_id,
        positive_overall_perception: positive_overall_perception,
        negative_overall_perception: negative_overall_perception,
        respondents_count: respondents_count
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
      [[:transparency, 55.0]]
    end

    private
    attr_reader :overall_by_areas
  end
end