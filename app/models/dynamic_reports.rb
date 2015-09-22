class DynamicReports
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
