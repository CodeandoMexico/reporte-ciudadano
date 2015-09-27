module DynamicReports

  class ServicePublicServantsReport
    include Datagrid

    scope do
      Admin.where(is_public_servant: true)
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:name)
    column(:is_service_admin)
    column(:dependency)
    column(:administrative_unit)
    column(:disabled)
    column(:is_observer)
    column(:email)

  end
  class  BestServiceReport
    include Datagrid

    scope do
      Service.includes(:service_surveys_reports)
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

    column(:overall_satisfaction, header: I18n.t('activerecord.attributes.dynamic_reports.overall_satisfaction')) do |record|
      unless elementos.blank?
        elementos= record.service_surveys_reports.map(&:positive_overall_perception)
        (elementos.reduce(:+)/elementos.count).round(2).to_s + "%"
      end
    end

  end

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
    column(:status, header: I18n.t('activerecord.attributes.dynamic_reports.status'))
    column(:survey_titles, header: I18n.t('activerecord.attributes.dynamic_reports.survey_titles')) do |record|
      record.service_surveys.map{|a| "#{a.title} - #{I18n.t("activerecord.attributes.dynamic_reports.open.#{a.open}")} "}.join(",")
    end
  end

  class  Panacea
    include Datagrid

    scope do
      ServiceSurveyReport.includes(:service_survey).includes(:services)
    end

    column(:service_id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:title, header: I18n.t('activerecord.attributes.dynamic_reports.title')) do |record|
      record.service_survey_title
    end
    column(:is_open, header: I18n.t('activerecord.attributes.dynamic_reports.is_open')) do |record|
      I18n.t(".#{record.service_survey.open}")
    end
    column(:phase, header: I18n.t('activerecord.attributes.dynamic_reports.phase')) do |record|
      I18n.t("service_survey_phase_options.#{record.service_survey_phase}")
    end
    column(:people_who_participated, header: I18n.t('activerecord.attributes.dynamic_reports.people_who_participated'))
    column(:positive_overall_perception, header: I18n.t('activerecord.attributes.dynamic_reports.positive_overall_perception'))
    column(:negative_overall_perception, header: I18n.t('activerecord.attributes.dynamic_reports.negative_overall_perception'))
    column(:people_who_participated, header: I18n.t('activerecord.attributes.dynamic_reports.people_who_participated'))
    column(:created_at, header: I18n.t('activerecord.attributes.dynamic_reports.created_at')) do |record|
      record.created_at.to_date
    end

    column(:areas_results, header: I18n.t('activerecord.attributes.dynamic_reports.areas_results')) do |record|
      """
      #{I18n.t("question_criterion_options.transparency")}: #{record.areas_results[:transparency]},
      #{I18n.t("question_criterion_options.performance")}: #{record.areas_results[:performance]},
      #{I18n.t("question_criterion_options.quality_service")}: #{record.areas_results[:quality_service]},
      #{I18n.t("question_criterion_options.accessibility")}: #{record.areas_results[:accessibility]},
      #{I18n.t("question_criterion_options.infrastructure")}: #{record.areas_results[:infrastructure]},
      #{I18n.t("question_criterion_options.public_servant")}: #{record.areas_results[:public_servant]}.
      """
    end
  end

end
