module DynamicReports
  class BestPublicServantsReport
    include Datagrid

    scope do
      ServiceReport.joins(:service)
    end

    def dependency_select
      scope.select("services.dependency").uniq.order("services.dependency").map(&:dependency)
    end

    def administrative_unit_select
      scope.select("services.administrative_unit").
        uniq.order("services.administrative_unit").map(&:administrative_unit)
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

    filter(:dependency,
           :enum,
           :select => :dependency_select,
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))  do |value, scope, grid|

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
    column(:dependency,:order => "services.dependency", header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.service.dependency
    end
    column(:administrative_unit, order: "services.administrative_unit", header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.service.administrative_unit
    end
    column(:cis, order: "services.cis", header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.service.cis.map{|service| "#{Services.service_cis_label(service)}"}.join("; ")
    end
    column(:areas_results, header: I18n.t('activerecord.attributes.dynamic_reports.public_servant_evaluation')) do |record|
     if record.overall_areas[:public_servant].round(2) > 85
      "#{record.overall_areas[:public_servant].round(2)}%"
     else
       I18n.t('activerecord.attributes.dynamic_reports.not_qualified')
     end


    end
  end

end
