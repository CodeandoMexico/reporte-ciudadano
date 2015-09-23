module DynamicReports

  class  ServiceStatusReport
    include Datagrid

    scope do
      Service.includes(:service_surveys)
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:dependency, header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.dependency
    end
    column(:cis, header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.cis.map do |cis_id|
        Services.service_cis_label(cis_id)
      end.join(";")
    end
    column(:service_name, header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |record|
      record.name + " (#{I18n.t("service_type_options.#{record.service_type}")})"
    end
    column(:survey_titles, header: I18n.t('activerecord.attributes.dynamic_reports.survey_titles')) do |record|
      record.service_surveys.map(&:title).join(",")
    end
    column(:is_open, header: I18n.t('activerecord.attributes.dynamic_reports.is_open')) do |record|
      I18n.t("activerecord.attributes.dynamic_reports.open.#{record.service_surveys.map(&:open).uniq.include?(true)}")
    end
  end

end
