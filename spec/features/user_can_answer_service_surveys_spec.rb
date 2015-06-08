require 'spec_helper'

feature 'User can answer service surveys' do
  let(:user) { create(:user) }

  background do
    sign_in_user user
  end

  scenario 'with binary questions' do
    service = create :service, name: "Actas de nacimiento"
    first_question = create :question, :binary, text: "¿Te pareció bueno el servicio?"
    second_question = create :question, :binary, text: "¿Se te brindó atención rápido?"
    survey = create(:service_survey, services: [service], title: "Encuesta acta de nacimiento", phase: "start", open: true, questions: [first_question, second_question])

    visit service_surveys_path
    click_link "Iniciar evaluación"

    within all(".pt-page").first do
      expect(current_path).to eq new_answer_path
      expect(page).to have_content "1 Pregunta restante"
      expect(page).to have_content "¿Te pareció bueno el servicio?"
      expect(page).not_to have_content "¿Se te brindó atención rápido?"

      choose "Sí"
      click_link "Siguiente pregunta"
    end

    within all(".pt-page")[1] do
      expect(page).to have_content "0 Preguntas restantes"
      expect(page).not_to have_content "¿Te pareció bueno el servicio?"
      expect(page).to have_content "¿Se te brindó atención rápido?"

      choose "No"
      click_button "Terminar evaluación"
    end

    expect(current_path).to eq service_surveys_path
    expect(page).to have_content "Gracias por evaluar el servicio."
  end

  scenario 'but only once' do
    service = create :service, name: "Actas de nacimiento"
    survey = create(:survey_with_binary_question, services: [service], title: "Encuesta acta de nacimiento", phase: "start", open: true)
    answer = create :survey_answer, user: user

    visit service_surveys_path
    expect(page).to have_content "Encuesta de acta de nacimiento"
    expect(page).not_to have_link "Iniciar evaluación"
  end
end