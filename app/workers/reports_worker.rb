class ReportsWorker
  include Sidekiq::Worker

  def perform(survey_id)
    survey = ServiceSurvey.find(survey_id)
    services = survey.services

    services.each do |service|
      Reports.build_report(nil, service.last_survey_reports, ServiceReport, service_id: service.id)
    end

    all_cis = services.map(&:cis).flatten.uniq

    all_cis.each do |cis|
      services_survey_reports = Service.for_cis(cis).map(&:last_survey_reports).flatten.uniq
      Reports.build_report(nil, services_survey_reports, CisReport, cis_id: cis)
    end
  end
end