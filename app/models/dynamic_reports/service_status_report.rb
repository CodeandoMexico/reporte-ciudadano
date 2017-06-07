module DynamicReports
  class  ServiceStatusReport
    include Datagrid

    scope do
      Service.includes(:service_surveys).uniq
    end


    filter(:id,
           :enum,
           :select => scope.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    filter(:created_at,
           :date,
           :range => true,
           :default => proc { [Service.all.select(:created_at).order("created_at ASC").first.blank? ? Date.today : Service.all.select(:created_at).order("created_at ASC").first.created_at,
                               Date.today]},
           header: I18n.t('activerecord.attributes.dynamic_reports.date_range'))

    filter(:organisation_id,
           :enum,
           :select => scope.select(:organisation_id)
           .uniq
           .order(:organisation_id)
           .map { |d| [d.dependency, d.organisation_id] },
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))

    filter(:agency_id,
           :enum,
           :select => scope.select(:agency_id)
           .uniq
           .order(:agency_id)
           .map { |d| [d.administrative_unit, d.agency_id] },
           :multiple => true, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'))

    filter(:cis,
           :enum,
           :select => scope.select(:cis).map{|a| a.cis}.flatten.uniq.map{|a| [Services.service_cis_label(a), a]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |value, scope, grid|

      scope.where("services.cis similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_name,
           :enum,
           :select => Service.order(:name).pluck(:name).uniq,
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |value, scope, grid|

      scope.where("services.name similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_type,
           :enum,
           :select => scope.select(:service_type).uniq.order(:service_type).
               map{|a| ["#{I18n.t("service_type_options.#{a.service_type}")}", a.service_type]},
          :multiple => true,
          header: I18n.t('activerecord.attributes.dynamic_reports.service_type')) do |value, scope, grid|

      scope.where("services.service_type similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:status,
           :enum,
           :select => scope.select(:status).uniq.map(&:status),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.status')) do |value, scope, grid|

      scope.where("services.status similar to ? ", "(#{value.uniq.join("|")})%")
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:created_at, order: "services.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.created_at')) do |record|
      record.created_at.to_date
    end
    column(:organisation_id, header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.dependency
    end
    column(:agency_id, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.administrative_unit
    end
    column(:cis, header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.cis.map do |cis_id|
        Services.service_cis_label(cis_id)
      end.join(";")
    end
    column(:service_name,order: "services.name", header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |record|
      record.name + " (#{I18n.t("service_type_options.#{record.service_type}")})"
    end
    column(:status, header: I18n.t('activerecord.attributes.dynamic_reports.status'))
  end
end
