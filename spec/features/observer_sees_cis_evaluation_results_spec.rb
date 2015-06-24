require 'spec_helper'

feature 'Observer can see cis evaluation results' do
  let(:observer) { create(:user, :observer) }

  scenario 'from dashboard' do
    service = create :service, name: "Actas de nacimiento", cis: ["1", "2"], admins: [create(:admin, :public_servant)]
    other_service = create :service, name: "Licencias", cis: ["1"], admins: create_list(:admin, 2, :public_servant)
    survey = create(:survey_with_binary_question, services: [service], title: "Encuesta acta de nacimiento", phase: "start", open: true)
    given_survey_has_answers survey

    sign_in_user observer
    expect(current_path).to eq evaluations_path

    expect(page).to have_content "Centro 1"
    expect(page).to have_content "Centro 2"
    expect(page).to have_content "Centro 3"
    expect(page).to have_content "Centro 4"

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
    given_survey_has_answers survey

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

  def given_survey_has_answers(survey)
    survey.questions.each do |question|
      user = create :user
      question.survey_answers = [ create(:survey_answer, question_id: question.id, score: question.value, user_id: user.id)]
      question.save
    end
  end
end