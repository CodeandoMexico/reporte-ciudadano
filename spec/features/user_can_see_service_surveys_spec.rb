require 'spec_helper'

feature 'User can see service surveys' do
  let(:user) { create(:user) }

  background do
    sign_in_user user
  end

  scenario 'from dashboard' do
    service = create :service, name: "Actas de nacimiento"
    survey = create(:survey_with_binary_question, services: [service], title: "Encuesta acta de nacimiento", phase: "start", open: true)

    click_link "Evalúa un servicio"

    expect(current_path).to eq service_surveys_path
    within '.service-surveys' do
      expect(page).to have_content "Encuesta acta de nacimiento"
      expect(page).to have_content "Actas de nacimiento"
      expect(page).to have_content "Al inicio"
      expect(page).to have_link "Iniciar evaluación"
    end

    expect(page).to have_link "Iniciar evaluación"
  end
end