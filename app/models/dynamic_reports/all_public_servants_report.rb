module DynamicReports
  class AllPublicServantsReport
    include Datagrid

    scope do
      ServiceReport.joins(:service)
    end

    def organisation_select
      scope.select("services.organisation_id").uniq.order("services.organisation_id").map { |d| [d.try(:dependency), d.try(:organisation_id)] }
    end

    def administrative_unit_select
      scope.select("services.agency_id").
        uniq.order("services.agency_id").map { |d| [d.try(:administrative_unit), d.try(:agency_id)] }
    end

    def cis_select
      scope.map{|a| a.service.cis}.flatten.uniq.map{|a| [Services.service_cis_label(a), a]}
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

      scope.where("service_reports.created_at between ? and ? ", value.first + 3.days, value.last + 1.days)
    end

    filter(:organisation_id,
           :enum,
           :select => :organisation_select,
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))do |value, scope, grid|

      scope.where("services.dependency similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:administrative_unit,
           :enum,
           :select => :administrative_unit_select,
           :multiple => true, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'),) do |value, scope, grid|

      scope.where("services.administrative_unit similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:cis,
           :enum,
           :select => :cis_select,
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |value, scope, grid|

      scope.where("services.cis similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:status,
           :enum,
           :select => scope.select(:status).uniq.map(&:status),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.status')) do |value, scope, grid|

      scope.where("services.status similar to ? ", "(#{value.uniq.join("|")})%")
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:date_start, :order => "service_reports.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_start')) do |record|
      record.created_at.to_date - 3.days
    end
    column(:date_end,:order => "service_reports.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_end')) do |record|
      record.created_at.to_date
    end
    column(:service_name, :order => "services.name",header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |record|
      record.service.name
    end
    column(:organisation_id,:order => "services.organisation_id", header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.service.dependency
    end
    column(:agency_id, order: "services.agency_id", header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.service.administrative_unit
    end
    column(:cis, order: "services.cis", header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.service.cis.map{|service| "#{Services.service_cis_label(service)}"}.join("; ")
    end
    column(:areas_results, header: I18n.t('activerecord.attributes.dynamic_reports.public_servant_evaluation')) do |record|
        "#{record.overall_areas[:public_servant].round(2)}%"
    end
  end

end
