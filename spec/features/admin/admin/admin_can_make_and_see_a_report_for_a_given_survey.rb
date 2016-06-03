require 'spec_helper'

feature 'Admin make a report' do
  let(:admin) { create(:admin) }

  scenario 'from service evaluations', js: true do
    user = create :user
    print user
    other_user = create :user
    print other_user
    service = create :service, name: "Actas de nacimiento", cis: ["1"], admins: [create(:admin, :public_servant)]
    other_service = create :service, name: "CURP", cis: ["2"], admins: [create(:admin, :public_servant)]

    survey = create(:survey_with_multiple_questions, services: [service, other_service], title: "Encuesta acta de nacimiento", phase: "start", open: true)

    given_survey_has_answers_for(survey, {user: user, binary: "Sí", rating: "Regular", list: "Custom", open: "Mis sugerencias", score: 1.0}, service.cis.last, other_service.id)
    given_survey_has_answers_for(survey, {user: other_user, binary: "Sí", rating: "Regular", list: "Custom", open: "Mis sugerencias", score: 1.0}, service.cis.last , other_service.id)
    given_survey_report_exists_for survey

    sign_in_admin admin

    visit evaluations_path

    expect(page).to have_content "Evaluaciones por servicio"
    expect(page).to have_content "Evaluaciones por Centro de atención"

    # Contenido en la tabla para service
    expect(find('.table-responsive tbody tr:nth-of-type(1) td:nth-of-type(1)')).to have_content "Actas de nacimiento"
    expect(find('.table-responsive tbody tr:nth-of-type(1) td:nth-of-type(2)')).to have_content "SSEP Hospital General de Puebla Sur (Módulo de afiliación del Seguro Popular)"
    expect(find('.table-responsive tbody tr:nth-of-type(1) td:nth-of-type(3)')).to have_content "1"
    expect(find('.table-responsive tbody tr:nth-of-type(1) td:nth-of-type(4)')).to have_content "0"

    # Contenido en la tabla para other_service
    expect(find('.table-responsive tbody tr:nth-of-type(2) td:nth-of-type(1)')).to have_content "CURP"
    expect(find('.table-responsive tbody tr:nth-of-type(2) td:nth-of-type(2)')).to have_content "CIS Centro Integral de Servicios Edificio Norte"
    expect(find('.table-responsive tbody tr:nth-of-type(2) td:nth-of-type(3)')).to have_content "1"
    expect(find('.table-responsive tbody tr:nth-of-type(2) td:nth-of-type(4)')).to have_content "2"

    visit root_path
    # KPI página principal de ciudadanos que han participado
    expect(find('.active-citizen-count .number-kpi')).to have_content "2"
    # KPI página principal de trámites evaluados
    expect(find('.services-count .number-kpi')).to have_content "2"
    # KPI página principal de servidores públicos evaluados
    expect(find('.public-servants-assesed .number-kpi')).to have_content "2"


  end


  def given_survey_has_answers_for(survey, answers_data, cis_id, service_id)
    survey.questions.each do |question|
      if [:binary, :rating].include? question.answer_type.to_sym
        SurveyAnswer.create!(text: answers_data[question.answer_type.to_sym], question_id: question.id, score: answers_data[:score] * question.value, user_id: answers_data[:user].id, cis_id: cis_id, service_id: service_id)
      else
        SurveyAnswer.create!(text: answers_data[question.answer_type.to_sym], question_id: question.id, score: nil, user_id: answers_data[:user].id, cis_id: cis_id, service_id: service_id)
      end
    end
  end

  def given_survey_report_exists_for(survey)
    survey.services.each do |a|
      ServiceSurveyReport.create!(service_survey_id: survey.id, service_id: a.id)
    end
  end
end