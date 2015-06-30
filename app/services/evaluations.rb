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
      service_surveys.map(&:reports).flatten
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
      100
    end
  end
end