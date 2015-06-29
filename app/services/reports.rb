module Reports
  def self.cis_report_for(cis, survey_reports:, translator:)
    CisReport.new(
      title: translator.call("cis_reports.title"),
      cis_data: cis,
      survey_reports: survey_reports
    )
  end

  class CisReport
    attr_reader :title

    def initialize(attrs)
      @title = attrs[:title]
      @survey_reports = attrs[:survey_reports]
    end

    def positive_overall
      survey_reports_to_quantify.sum / (survey_reports_to_quantify.count * 1.0)
    end

    def negative_overall
      100.0 - positive_overall
    end

    private
    attr_reader :survey_reports

    def survey_reports_to_quantify
      survey_reports
        .map(&:positive_overall_perception)
        .select(&:present?)
    end
  end
end