module Evaluations
  def self.cis_with_results(cis_array, services_records)
    cis_array.map { |cis| Cis.new(cis, services_records: services_records) }
  end

  def self.cis_evaluation_for(cis, services_records)
    Cis.new(cis, services_records: services_records)
  end

  private

  class Cis
    attr_reader :name, :id

    def initialize(attrs, services_records:)
      @id = attrs[:id]
      @name = attrs[:name]
      @services_records = services_records || []
    end

    def evaluated_services_count
      services.count
    end

    def evaluated_public_servants_count
      services.map(&:admins).uniq.count
    end

    def survey_participants_count
      survey_participants_ids.count
    end

    def services
      services_records
        .select { |service| Services.is_assigned_to_cis?(service, id)}
        .map { |service| ServiceEvaluation.new(service) }
    end

    def service_surveys_reports
      service_surveys.map(&:last_report).flatten.reject(&:blank?)
    end

    def best_evaluated_service
      services
        .select { |service| service.positive_overall_perception.present? }
        .max_by(&:positive_overall_perception)
    end

    def worst_evaluated_service
      services
        .select { |service| service.positive_overall_perception.present? }
        .min_by(&:positive_overall_perception)
    end

    private
    attr_reader :services_records

    def service_surveys
      services.map(&:service_surveys).flatten
    end

    def survey_participants_ids
      service_surveys
        .map(&:answers)
        .flatten
        .map(&:user_id)
        .uniq
    end
  end

  class ServiceEvaluation < SimpleDelegator
    def overall_evaluation_for(criterion)
      return report.overall_areas[criterion] if report.present?
      return 0.0 if last_survey_reports.empty?
      total_by_area(last_survey_reports.map(&:areas_results), criterion, 0.0) / last_survey_reports.size
    end

    def positive_overall_perception
      return report.positive_overall_perception if report.present?
      return nil if last_survey_reports.empty?
      last_survey_reports.map(&:positive_overall_perception).sum / last_survey_reports.size
    end

    def report
      Reports.current_service_report_for(self,
      services_report_store: ServiceReport)
    end

    private

    def total_by_area(areas_hash_array, key, acc)
      return acc if areas_hash_array.empty?
      next_value = areas_hash_array.shift[key]
      total_by_area(areas_hash_array, key, acc + next_value)
    end
  end
end