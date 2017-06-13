module DynamicReports
  class ServicePerformanceReport
    include Datagrid

    scope do
      ServiceReport.joins(:service)
    end

    def service_select
      scope.select("services.name").uniq.order("services.name").map(&:name)
    end

    def organisation_select
      scope.select("services.organisation_id")
        .uniq
        .order("services.organisation_id")
        .map { |d| [d.try(:dependency), d.try(:organisation_id)] }
    end

    def agency_select
      scope.select("services.agency_id")
        .uniq
        .order("services.agency_id")
        .map { |d| [d.try(:administrative_unit), d.try(:agency_id)] }
    end

    filter(:id,
           :enum,
           :select => Service.all.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    filter(:created_at,
          :date,
          :range => true,
          :default => proc { [1.month.ago.to_date, Date.today]},
          header: I18n.t('activerecord.attributes.dynamic_reports.date_range')) do |value, scope, grid|

     scope.where("service_reports.created_at between ? and ? ", value.first + 3.days, value.last + 1.days)
    end

    filter(:organisation_id,
           :enum,
           :select => :organisation_select,
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))  do |value, scope, grid|

      scope.where("services.dependency similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:agency_id,
           :enum,
           :select => :agency_select,
           :multiple => true, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'),) do |value, scope, grid|

      scope.where("services.administrative_unit similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_name,
           :enum,
           :select => :service_select,
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |value, scope, grid|

      scope.where("services.name similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    column(:date_start, order:"service_reports.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_start')) do |record|
      record.created_at.to_date - 3.days
    end
    column(:date_end, order:"service_reports.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_end')) do |record|
      record.created_at.to_date
    end
    column(:organisation_id, order:"services.dependency", header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.service.dependency
    end
    column(:agency_id, order: "services.administrative_unit", header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.service.administrative_unit
    end
    column(:service_name,order: "services.name" , header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |record|
      record.service.name
    end
    column(:service_surveys, header: I18n.t('activerecord.attributes.dynamic_reports.service_surveys_count')) do |record|
      record.service.service_surveys.count
    end
    column(:respondents_count, header: I18n.t('activerecord.attributes.dynamic_reports.respondents_count')) do |record|
      "#{record.respondents_count}"
    end
  end
end
