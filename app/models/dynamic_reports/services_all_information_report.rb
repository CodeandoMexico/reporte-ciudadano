module DynamicReports
  class  ServicesAllInformationReport
    include Datagrid

    scope do
      Service.includes(:service_surveys).includes(:service_reports)
    end

    def service_select
      scope.select(:name).uniq.order(:name).map(&:name)
    end

    def organisation_select
      scope
        .select(:organisation_id)
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

    def cis_select
      scope.select(:cis).map{|a| a.cis}.flatten.uniq.map{|a| [Services.service_cis_label(a), a]}
    end

    def status_select
      scope.select(:status).uniq.map(&:status)
    end

    def id_select
      scope.select(:id).uniq.order(:id).map(&:id)
    end

    filter(:id,
           :enum,
           :select => :id_select,
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    filter(:created_at,
           :date,
           :range => true,
           :default => proc { [1.month.ago.to_date, Date.today]},
           header: I18n.t('activerecord.attributes.dynamic_reports.date_range'))

    filter(:organisation_id,
           :enum,
           :select => :organisation_select,
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))

    filter(:agency_id,
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
           :select => :status_select,
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.status')) do |value, scope, grid|

      scope.where("services.status similar to ? ", "(#{value.uniq.join("|")})%")
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    column(:created_at, order: "services.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.created_at')) do |record|
      record.created_at.to_date
    end
    column(:name, header: I18n.t('activerecord.attributes.dynamic_reports.name')) do |record|
      record.name
    end
    column(:service_type, :order => "services.name" , header: I18n.t('activerecord.attributes.dynamic_reports.service_type')) do |record|
      "(#{I18n.t("service_type_options.#{record.service_type}")})"
    end
    column(:organisation_id, header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.dependency
    end
    column(:agency_id, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.administrative_unit
    end
    column(:manager, header: I18n.t('activerecord.attributes.dynamic_reports.admins')) do |record|
      "#{record.service_admin.try(:name)} #{record.service_admin.try(:surname)}"
    end
    column(:admins, header: I18n.t('activerecord.attributes.dynamic_reports.public_servant')) do |record|
      record.admins.map{|a| "#{a.try(:name)} #{a.try(:surname)}" }.join("; ")
    end
    column(:cis, header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.cis.map do |cis_id|
        Services.service_cis_label(cis_id)
      end.join(";")
    end
    column(:title, header: I18n.t('activerecord.attributes.dynamic_reports.survey_titles')) do |record|
      record.service_surveys.map(&:title).join(";")
    end
    column(:people_who_participated, header: I18n.t('activerecord.attributes.dynamic_reports.people_who_participated'))  do |record|
      record.service_reports.map(&:respondents_count).reduce(:+)
    end
    column(:positive_overall_perception, header: I18n.t('activerecord.attributes.dynamic_reports.positive_overall_perception')) do |record|
      if record.service_reports.order(:created_at).map(&:positive_overall_perception).last
        "#{record.service_reports.order(:created_at).map(&:positive_overall_perception).last}%"
      else
        I18n.t('activerecord.attributes.dynamic_reports.not_evaluated')
      end
    end


    column(:areas_results, header: I18n.t("question_criterion_options.transparency")) do |record|
      if record.service_reports.order(:created_at).map{|a| a.overall_areas[:transparency]}.last
        """
          #{record.service_reports.order(:created_at).map{|a| a.overall_areas[:transparency]}.last.round(2)} %
        """
      end

    end


    column(:areas_results, header: I18n.t("question_criterion_options.performance")) do |record|
      if record.service_reports.order(:created_at).map{|a| a.overall_areas[:performance]}.last
        """
          #{record.service_reports.order(:created_at).map{|a| a.overall_areas[:performance]}.last.round(2)} %
        """
      else
        I18n.t('activerecord.attributes.dynamic_reports.not_evaluated')
      end

    end

    column(:areas_results, header: I18n.t("question_criterion_options.quality_service")) do |record|
      if record.service_reports.order(:created_at).map{|a| a.overall_areas[:quality_service]}.last
        """
          #{record.service_reports.order(:created_at).map{|a| a.overall_areas[:quality_service]}.last.round(2)} %
        """
      else
        I18n.t('activerecord.attributes.dynamic_reports.not_evaluated')
      end

    end

    column(:areas_results, header: I18n.t("question_criterion_options.accessibility")) do |record|
      if record.service_reports.order(:created_at).map{|a| a.overall_areas[:accessibility]}.last
        """
          #{record.service_reports.order(:created_at).map{|a| a.overall_areas[:accessibility]}.last.round(2)} %
        """
      else
        I18n.t('activerecord.attributes.dynamic_reports.not_evaluated')
      end

    end

    column(:areas_results, header: I18n.t("question_criterion_options.infrastructure")) do |record|
      if record.service_reports.order(:created_at).map{|a| a.overall_areas[:infrastructure]}.last
        """
          #{record.service_reports.order(:created_at).map{|a| a.overall_areas[:infrastructure]}.last.round(2)} %
        """
      else
        I18n.t('activerecord.attributes.dynamic_reports.not_evaluated')
      end

    end

    column(:areas_results, header: I18n.t("question_criterion_options.public_servant")) do |record|
      if record.service_reports.order(:created_at).map{|a| a.overall_areas[:public_servant]}.last
        """
          #{record.service_reports.order(:created_at).map{|a| a.overall_areas[:public_servant]}.last.round(2)} %
        """
      else
        I18n.t('activerecord.attributes.dynamic_reports.not_evaluated')
      end
    end

  end

end
