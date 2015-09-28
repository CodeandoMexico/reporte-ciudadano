module DynamicReports

  class CisServices
    include Datagrid

    scope do
      CisReport
      # Services.service_cis_options.to_a
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:cis_name, header: I18n.t('activerecord.attributes.dynamic_reports.cis'))do |record|
      Services.service_cis_label(record.cis_id.to_s)
    end
    column(:cis_services, header: I18n.t('activerecord.attributes.dynamic_reports.cis_services'))do |record|
      Service.for_cis(record.cis_id).map{|service| "#{service.name}"}.join("; ")
    end
    column(:positive_overall_perception, header: I18n.t('activerecord.attributes.dynamic_reports.positive_overall_perception')) do |record|
      "#{record.positive_overall_perception}%"
    end
    column(:respondents_count, header: I18n.t('activerecord.attributes.dynamic_reports.respondents_count')) do |record|
      "#{record.respondents_count}"
    end

  end

  class ServicePublicServantsReport
    include Datagrid

    scope do
      Admin.where(is_public_servant: true).joins(:services).distinct(:id)
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:name, header: I18n.t('activerecord.attributes.dynamic_reports.name'))
    column(:administrative_unit, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'))
    column(:dependency, header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))
    column(:disabled, header: I18n.t('activerecord.attributes.dynamic_reports.disabled')) do |record|
      I18n.t("activerecord.attributes.dynamic_reports.affirmation.#{record.disabled}")
    end
    column(:is_service_admin, header: I18n.t('activerecord.attributes.dynamic_reports.is_service_admin'))do |record|
      I18n.t("activerecord.attributes.dynamic_reports.affirmation.#{!!record.is_service_admin}")
    end

    column(:is_observer, header: I18n.t('activerecord.attributes.dynamic_reports.is_observer')) do |record|
      I18n.t("activerecord.attributes.dynamic_reports.affirmation.#{record.is_observer}")
    end
    column(:service_names, header: I18n.t('activerecord.attributes.dynamic_reports.service_names')) do |record|
      record.services.map{|b| "#{b.name}"}.join("; ")
    end

  end

  class BestPublicServantsReport
    include Datagrid

    scope do
      ServiceReport.joins(:service)
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:created_at, header: I18n.t('activerecord.attributes.dynamic_reports.created_at')) do |record|
      record.created_at.to_date
    end
    column(:administrative_unit, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.service.administrative_unit
    end
    column(:dependency, header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.service.dependency
    end
    column(:cis, header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.service.cis
    end
    column(:service_name, header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |record|
      record.service.name
    end
    column(:areas_results, header: I18n.t('activerecord.attributes.dynamic_reports.public_servant_evaluation')) do |record|
      record.overall_areas[:public_servant]

    end
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
      elementos= record.service_surveys_reports.map(&:positive_overall_perception)
      unless elementos.blank?
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
    column(:administrative_unit, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.administrative_unit
  end
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
    column(:people_who_participated, header: I18n.t('activerecord.attributes.dynamic_reports.people_who_participated'))
    column(:created_at, header: I18n.t('activerecord.attributes.dynamic_reports.created_at')) do |record|
      record.created_at.to_date
    end
    column(:positive_overall_perception, header: I18n.t('activerecord.attributes.dynamic_reports.positive_overall_perception')) do |record|
      "#{record.positive_overall_perception}%"
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
