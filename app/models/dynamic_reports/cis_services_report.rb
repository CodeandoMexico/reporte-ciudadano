module DynamicReports
  class CisServicesReport
    include Datagrid

    scope do
      CisReport
    end

    filter(:id,
           :enum,
           :select => scope.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))


    filter(:created_at,
           :date,
           :range => true,
           :default => proc { [1.month.ago.to_date, Date.today]},
           header: I18n.t('activerecord.attributes.dynamic_reports.date_range')) do |value, scope, grid|
      scope.where("cis_reports.created_at between ? and ? ", value.first + 3.days, value.last + 1.days)
    end

    filter(:cis_id,
           :enum,
           :select => scope.select(:cis_id).uniq.map{|a| a}.flatten.uniq.map{|a| [Services.service_cis_label(a.cis_id.to_s), a.cis_id]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |value, scope, grid|

      scope.where(cis_id: value.uniq.join(","))
    end
    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:date_start, order:"created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_start')) do |record|
      record.created_at.to_date - 3.days
    end
    column(:date_end, order:"created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_end')) do |record|
      record.created_at.to_date
    end
    column(:cis_name, order: "cis_id", header: I18n.t('activerecord.attributes.dynamic_reports.cis'))do |record|
      Services.service_cis_label(record.cis_id.to_s)
    end
    column(:cis_services,  header: I18n.t('activerecord.attributes.dynamic_reports.cis_services'))do |record|
      Service.for_cis(record.cis_id).map{|service| "#{service.name}"}.join("; ")
    end
    column(:positive_overall_perception, header: I18n.t('activerecord.attributes.dynamic_reports.positive_overall_perception')) do |record|
      "#{record.positive_overall_perception.round(2)}%"
    end
    column(:respondents_count, header: I18n.t('activerecord.attributes.dynamic_reports.respondents_count')) do |record|
      "#{record.respondents_count}"
    end
    column(:overall_areas, order: false, header: I18n.t('activerecord.attributes.dynamic_reports.transparency')) do |record|
      "#{record.overall_areas[:transparency].round(2)}%"
    end
    column(:overall_areas, order: false, header: I18n.t('activerecord.attributes.dynamic_reports.performance')) do |record|
      "#{record.overall_areas[:performance].round(2)}%"
    end
    column(:overall_areas, order: false, header: I18n.t('activerecord.attributes.dynamic_reports.quality_service')) do |record|
      "#{record.overall_areas[:quality_service].round(2)}%"
    end
    column(:overall_areas, order: false, header: I18n.t('activerecord.attributes.dynamic_reports.accessibility')) do |record|
      "#{record.overall_areas[:accessibility].round(2)}%"
    end
    column(:overall_areas, order: false, header: I18n.t('activerecord.attributes.dynamic_reports.infrastructure')) do |record|
      "#{record.overall_areas[:infrastructure].round(2)}%"
    end
    column(:overall_areas, order: false, header: I18n.t('activerecord.attributes.dynamic_reports.public_servant')) do |record|
      "#{record.overall_areas[:public_servant].round(2)}%"
    end
  end
end