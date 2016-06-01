require 'spec_helper'

feature 'User can answer service surveys' do
  let(:user) { create(:user) }

  background do
    sign_in_user user
  end

  scenario 'with binary questions', js: true do
    service = create :service, name: "Actas de nacimiento"
    second_question = create :question, :binary, text: "¿Te pareció bueno el servicio?", value: 50
    first_question = create :question, :binary, text: "¿Se te brindó atención rápido?", value: 50
    survey = create(:service_survey, services: [service], title: "Encuesta acta de nacimiento", phase: "start", open: true, questions: [first_question, second_question])

    visit service_surveys_path
    select_from_chosen_by_css 'Al inicio - Encuesta acta de nacimiento ', from: '#service_survey_selector'
    select_from_chosen_by_css 'SSEP Hospital General de Puebla Sur (Módulo de afiliación del Seguro Popular)', from: '#cis_selector'
    click_link "Iniciar evaluación"

    within (".pt-page-current") do
      expect(current_path).to eq new_answer_path
      expect(page).to have_content "1 Pregunta restante"
      expect(page).to have_content "¿Te pareció bueno el servicio?"

      choose "Sí"
      click_link "Siguiente pregunta"
    end

    within (".pt-page-current") do
      expect(page).to have_content "0 Preguntas restantes"
      expect(page).not_to have_content "¿Te pareció bueno el servicio?"
      expect(page).to have_content "¿Se te brindó atención rápido?"

      choose "No"
      click_button "Terminar evaluación"
    end

    expect(current_url).to include service_survey_reports_path(service_survey_id: survey.id)
    expect(page).to have_content "Gracias por evaluar el servicio."
    expect_survey_confirmation_email_sent_to user.email
  end

  scenario 'and answer another survey' do
    service = create :service, name: "Actas de nacimiento"
    question = create :question, :binary, text: "¿Te pareció bueno el servicio?", value: 100
    survey = create(:service_survey, services: [service], title: "Encuesta acta de nacimiento", phase: "start", open: true, questions: [question])

    visit new_answer_path(service_survey_id: survey.id, cis_id: 1, service_id: 1)

    within all(".pt-page").first do
      expect(page).to have_button "Terminar evaluación"
      expect(page).to have_content "¿Te pareció bueno el servicio?"
      choose "Sí"
    end

    click_button "Terminar evaluación"
    expect_survey_confirmation_email_sent_to user.email
    expect(page).to have_content "Gracias por evaluar el servicio."
  end

  scenario 'but only once', js: true do
    service = create :service, name: "Actas de nacimiento"
    survey = create(:survey_with_binary_question, services: [service], title: "Encuesta acta de nacimiento", phase: "start", open: true)
    answer = create(:survey_answer, user_id: user.id, question_id: survey.questions.first.id, cis_id: 1, service_id: service.id)

    visit service_surveys_path
    within all(".service-surveys").first do
      select_from_chosen_by_css 'Al inicio - Encuesta acta de nacimiento ', from: '#service_survey_selector'
      select_from_chosen_by_css 'SSEP Hospital General de Puebla Sur (Módulo de afiliación del Seguro Popular)', from: '#cis_selector'
      expect(page).to have_content "Encuesta acta de nacimiento"
      expect(page).to have_content "Evaluada"
      expect(page).not_to have_link "Iniciar evaluación"
    end

    visit new_answer_path(service_survey_id: survey.id, cis_id: 1, service_id: service)
    expect(page).to have_content "Ya has evaluado la encuesta seleccionada."
  end

  scenario 'with optional and required questions', js: true do
    service = create :service, name: "Actas de nacimiento"
    second_question = create :question, :binary, text: "¿Te pareció bueno el servicio?", value: 50, optional: true
    first_question = create :question, :binary, text: "¿Se te brindó atención rápido?", value: 50, optional: false
    survey = create(:service_survey, services: [service], title: "Encuesta acta de nacimiento", phase: "start", open: true, questions: [first_question, second_question])

    visit service_surveys_path
    select_from_chosen_by_css 'Al inicio - Encuesta acta de nacimiento ', from: '#service_survey_selector'
    select_from_chosen_by_css 'SSEP Hospital General de Puebla Sur (Módulo de afiliación del Seguro Popular)', from: '#cis_selector'
    click_link "Iniciar evaluación"

    within (".pt-page-current") do
      expect(page).to have_content "1 Pregunta restante"
      expect(page).to have_content "¿Te pareció bueno el servicio?"
      expect(next_question_button).not_to be_disabled

      click_link "Siguiente pregunta"
    end

    within (".pt-page-current") do
      expect(page).not_to have_content "¿Te pareció bueno el servicio?"
      expect(page).to have_content "¿Se te brindó atención rápido?"
      expect(disabled_finish_survey_button).to be_disabled
      expect(page).to have_content "Necesitas responder esta pregunta para continuar."

      choose "No"
      click_button "Terminar evaluación"
    end
    expect(page).to have_content "Gracias por evaluar el servicio."
  end

  def expect_survey_confirmation_email_sent_to(email)
    last_email = ActionMailer::Base.deliveries.last || :no_email_sent
    expect(last_email.to).to include(email)
    expect(last_email.subject).to include "Gracias por tu evaluación"
  end

  def disabled_finish_survey_button
    find_button "Terminar evaluación", disabled: true
  end

  def next_question_button
    find(".pt-trigger")
  end
end