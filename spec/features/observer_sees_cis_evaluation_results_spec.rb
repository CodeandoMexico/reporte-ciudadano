require 'spec_helper'

feature 'Observer can see cis evaluation results' do
  let(:observer) { create(:user, :observer) }

  scenario 'from dashboard' do
    service = create :service, name: "Actas de nacimiento", cis: ["1", "2"], admins: [create(:admin, :public_servant)]
    other_service = create :service, name: "Licencias", cis: ["1"], admins: create_list(:admin, 2, :public_servant)
    survey = create(:survey_with_binary_question, services: [service], title: "Encuesta acta de nacimiento", phase: "start", open: true)
    given_survey_has_answers survey, 1.0
    given_survey_report_exists_for survey

    sign_in_user observer
    expect(current_path).to eq evaluations_path

    expect(page).to have_content cis_name

    within first('.cis') do
      expect(page).to have_link "Ver resultados"
      click_link "Ver resultados"
    end

    expect(current_path).to eq cis_evaluation_path(id: 1)
    within '.evaluation-overview-participants' do
      expect(page).to have_content 1
    end

    within '.evaluation-overview-services' do
      expect(page).to have_content 2
    end

    within '.evaluation-overview-public-servants' do
      expect(page).to have_content 2
    end
  end

  scenario 'with services results' do
    service = create :service, name: "Actas de nacimiento", cis: ["1", "2"], admins: [create(:admin, :public_servant)]
    other_service = create :service, name: "Licencias", cis: ["1"], admins: create_list(:admin, 2, :public_servant)
    survey = create(:survey_with_binary_question, services: [service], title: "Encuesta acta de nacimiento", phase: "start", open: true)
    given_survey_has_answers survey, 1.0
    given_survey_report_exists_for survey

    sign_in_user observer
    visit cis_evaluation_path(id: 1)

    within '.evaluation-services' do
      expect(page).to have_content "Transparencia"
      expect(page).to have_content "Desempeño"
      expect(page).to have_content "Calidad de servicio"
      expect(page).to have_content "Accesibilidad"
      expect(page).to have_content "Infraestructura"
      expect(page).to have_content service.name
      expect(page).to have_content other_service.name
    end
  end

  scenario 'with best and worst evaluated services' do
    service = create :service, name: "Actas de nacimiento", cis: ["1", "2"], admins: [create(:admin, :public_servant)]
    other_service = create :service, name: "Licencias", cis: ["1"], admins: create_list(:admin, 2, :public_servant)
    not_evaluated_service = create :service, name: "No evaluado", cis: ["1"], admins: create_list(:admin, 2, :public_servant)
    survey = create(:survey_with_binary_question, services: [service], title: "Encuesta acta de nacimiento", phase: "start", open: true)
    other_survey = create(:survey_with_binary_question, services: [other_service], title: "Encuesta Licencias", phase: "start", open: true)

    given_survey_has_answers(survey, 1.0)
    given_survey_has_answers(other_survey, 0.0)
    given_survey_report_exists_for survey
    given_survey_report_exists_for other_survey

    sign_in_user observer
    visit cis_evaluation_path(id: 1)

    within '.best-service' do
      expect(page).to have_content "Actas de nacimiento"
    end

    within '.worst-service' do
      expect(page).to have_content "Licencias"
    end
  end

  scenario 'with best and worst public servants evaluated services' do
    service = create :service, name: "Actas de nacimiento", cis: ["1", "2"], admins: [create(:admin, :public_servant)]
    other_service = create :service, name: "Licencias", cis: ["1"], admins: create_list(:admin, 2, :public_servant)
    not_evaluated_service = create :service, name: "No evaluado", cis: ["1"], admins: create_list(:admin, 2, :public_servant)
    survey = create(:survey_with_binary_question, services: [service], title: "Encuesta acta de nacimiento", phase: "start", open: true)
    other_survey = create(:survey_with_binary_question, services: [other_service], title: "Encuesta Licencias", phase: "start", open: true)

    given_survey_has_answers(survey, 1.0)
    given_survey_has_answers(other_survey, 0.0)
    survey_report = given_survey_report_exists_for survey
    other_survey_report = given_survey_report_exists_for other_survey

    given_report_has_public_servants_evaluation survey_report, 60.0
    given_report_has_public_servants_evaluation other_survey_report, 80.0

    sign_in_user observer
    visit cis_evaluation_path(id: 1)

    within '.best-public-servants' do
      expect(page).not_to have_content "Actas de nacimiento"
      expect(page).to have_content "Licencias"
    end

    within '.worst-public-servants' do
      expect(page).not_to have_content "Licencias"
      expect(page).to have_content "Actas de nacimiento"
    end
  end

  scenario 'with no evaluated services message' do
    services = create_list(:service, 3, cis: ["1", "2"], admins: [create(:admin, :public_servant)])

    sign_in_user observer
    visit cis_evaluation_path(id: 1)

    within '.evaluation-overall' do
      expect(page).to have_content "No hay datos en reportes de encuestas para generar el reporte."
    end

    within '.best-service' do
      expect(page).to have_content "Ningún servicio ha sido evaluado o no tiene encuestas respondidas."
    end

    within '.worst-service' do
      expect(page).to have_content "Ningún servicio ha sido evaluado o no tiene encuestas respondidas."
    end

    within '.best-public-servants' do
      expect(page).to have_content "Ningún servicio ha sido evaluado o no tiene encuestas respondidas."
    end

    within '.worst-public-servants' do
      expect(page).to have_content "Ningún servicio ha sido evaluado o no tiene encuestas respondidas."
    end
  end

  def given_report_has_public_servants_evaluation(report, percentage)
    report.areas_results[:public_servant] = percentage
    report.save
  end

  def given_survey_report_exists_for(survey)
    ServiceSurveyReport.create!(service_survey_id: survey.id)
  end

  def given_survey_has_answers(survey, answer_value)
    survey.questions.each do |question|
      user = create :user
      question.survey_answers = [ create(:survey_answer, question_id: question.id, score: answer_value * question.value, user_id: user.id)]
      question.save
    end
  end
end