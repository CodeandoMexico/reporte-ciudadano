module DynamicReports
  class  WorstServiceReport
    include Datagrid

    scope do
      Service.joins(:service_surveys_reports).uniq
    end

    def service_select
      scope.select(:name).uniq.order(:name).map(&:name)
    end

    def cis_select
      scope.select(:cis).map{|a| a.cis}.flatten.uniq.map{|a| [Services.service_cis_label(a), a]}
    end

    def organisation_select
      scope.select(:organisation_id)
        .uniq
        .order(:organisation_id)
        .map { |d| [d.dependency, d.organisation_id] }
    end

    def agency_select
      scope.select(:agency_id)
        .uniq
        .order(:agency_id)
        .map { |d| [d.administrative_unit, d.agency_id] }
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

      scope.where("service_survey_reports.created_at between ? and ? ", value.first + 3.days, value.last + 1.days)
    end

    filter(:organisation_id,
           :enum,
           :select => :organisation_select,
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))

    filter(:administrative_unit,
           :enum,
           :select => :agency_select,
           :multiple => true, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'),)

    filter(:cis,
           :enum,
           :select => :cis_select,
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |value, scope, grid|

      scope.where("services.cis similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_name,
           :enum,
           :select => :service_select,
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
    column(:date_start, :order => "services.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_start')) do |record|
      record.created_at.to_date - 3.days
    end
    column(:date_end, :order => "services.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_end')) do |record|
      record.created_at.to_date
    end
    column(:organisation_id, :order => "services.organisation_id", header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.dependency
    end
    column(:agency_id, :order => "services.agency_id", header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.administrative_unit
    end

    column(:cis, :order => "services.cis", header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.cis.map do |cis_id|
        Services.service_cis_label(cis_id)
      end.join(";")
    end

    column(:service_name, :order => "services.name", header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |record|
      record.name + " (#{I18n.t("service_type_options.#{record.service_type}")})"
    end

    column(:overall_satisfaction, header: I18n.t('activerecord.attributes.dynamic_reports.overall_satisfaction')) do |record|
      elementos= record.service_surveys_reports.map(&:positive_overall_perception)
      unless elementos.blank?
        if (elementos.reduce(:+)/elementos.count).round(2) < 70
          (elementos.reduce(:+)/elementos.count).round(2).to_s + "%"
        else
          I18n.t('activerecord.attributes.dynamic_reports.not_qualified')
        end
      end
    end

  end

end
