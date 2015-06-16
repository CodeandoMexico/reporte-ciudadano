require 'spec_helper'

feature 'As a service admin I can create a new survey' do

  let(:admin) { create(:admin, :service_admin) }

  background do
    sign_in_admin admin
  end

  scenario 'Assigned to a service' do
    service = create :service, name: "Mi servicio", service_admin: admin

    visit admins_dashboards_path
    click_link "Encuestas de servicio"
    click_link "Crear nueva encuesta"

    fill_in "service_survey_title", with: "La encuesta de mi servicio"
    check "service_survey_service_ids_#{service.id}"
    choose 'A la mitad'
    click_button "Guardar"

    expect(page).to have_content "La encuesta se ha creado exitosamente."
    expect(page).to have_content "La encuesta de mi servicio"
    expect(page).to have_content "A la mitad"
    expect(current_path).to eq admins_service_surveys_path
  end

  scenario 'With questions and binary answers', js: true do
    service = create :service, name: "Mi servicio", service_admin: admin

    visit admins_dashboards_path
    click_link "Encuestas de servicio"
    click_link "Crear nueva encuesta"

    check "service_survey_service_ids_#{service.id}"
    choose 'A la mitad'
    click_link "Agregar pregunta"

    select "Transparencia", from: "Criterio a evaluar"
    fill_in "Texto", with: "¿ Te gustó el servicio ?"
    select "Seleccionar de 2 posibles (Sí/No)", from: "Tipo de respuesta"
    fill_in "Valor %", with: 100

    expect(page).to have_content "Sí"
    expect(page).to have_content "No"

    click_button "Guardar"

    expect(page).to have_content "La encuesta se ha creado exitosamente."
    expect(current_path).to eq admins_service_surveys_path
  end

  scenario 'With questions and rating answers', js: true do
    service = create :service, name: "Mi servicio", service_admin: admin

    visit admins_dashboards_path
    click_link "Encuestas de servicio"
    click_link "Crear nueva encuesta"

    check "service_survey_service_ids_#{service.id}"
    choose 'A la mitad'
    click_link "Agregar pregunta"

    select "Desempeño", from: "Criterio a evaluar"
    fill_in "Texto", with: "¿ Qué tan bueno te pareció el servicio ?"
    select "Seleccionar de 5 posibles en un rango", from: "Tipo de respuesta"
    choose "Muy bueno - Muy malo"
    fill_in "Valor %", with: 100

    expect(page).to have_content "Muy bueno"
    expect(page).to have_content "Bueno"
    expect(page).to have_content "Regular"
    expect(page).to have_content "Malo"
    expect(page).to have_content "Muy malo"

    click_button "Guardar"

    expect(page).to have_content "La encuesta se ha creado exitosamente."
    expect(current_path).to eq admins_service_surveys_path
  end

  scenario 'With questions and open answers', js: true do
    service = create :service, name: "Mi servicio", service_admin: admin

    visit admins_dashboards_path
    click_link "Encuestas de servicio"
    click_link "Crear nueva encuesta"

    check "service_survey_service_ids_#{service.id}"
    choose 'A la mitad'
    click_link "Agregar pregunta"

    select "Desempeño", from: "Criterio a evaluar"
    fill_in "Texto", with: "¿ Qué sugerencias tienes para el servicio ?"
    select "Respuesta abierta", from: "Tipo de respuesta"

    expect(page).to have_content "Texto introducido por el usuario..."

    click_button "Guardar"

    expect(page).to have_content "La encuesta se ha creado exitosamente."
    expect(current_path).to eq admins_service_surveys_path
  end

  scenario 'With questions and list answers', js: true do
    service = create :service, name: "Mi servicio", service_admin: admin

    visit admins_dashboards_path
    click_link "Encuestas de servicio"
    click_link "Crear nueva encuesta"

    check "service_survey_service_ids_#{service.id}"
    choose 'A la mitad'
    click_link "Agregar pregunta"

    select "Desempeño", from: "Criterio a evaluar"
    fill_in "Texto", with: "¿ Qué esperarías que mejorara del servicio ?"
    select "Seleccionar de una lista", from: "Tipo de respuesta"

    expect(custom_answers_count).to eq 5

    fill_custom_answer 1,  "Que sea más rápido"
    fill_custom_answer 2,  "Que sean más amables"

    click_button "Guardar"

    expect(page).to have_content "La encuesta se ha creado exitosamente."
    expect(current_path).to eq admins_service_surveys_path
  end

  scenario 'With multiple type of questions', js: true do
    service = create :service, name: "Mi servicio", service_admin: admin

    visit admins_dashboards_path
    click_link "Encuestas de servicio"
    click_link "Crear nueva encuesta"

    check "service_survey_service_ids_#{service.id}"
    choose 'A la mitad'

    click_link "Agregar pregunta"

    within first(".nested-fields") do
      select "Desempeño", from: "Criterio a evaluar"
      fill_in "Texto", with: "¿ Qué tan bueno te pareció el servicio ?"
      select "Seleccionar de 5 posibles en un rango", from: "Tipo de respuesta"
      choose "Muy bueno - Muy malo"
      fill_in "Valor %", with: 50
    end

    click_link "Agregar pregunta"

    within all(".nested-fields")[1] do
      select "Transparencia", from: "Criterio a evaluar"
      fill_in "Texto", with: "¿ Te gustó el servicio ?"
      select "Seleccionar de 2 posibles (Sí/No)", from: "Tipo de respuesta"
      fill_in "Valor %", with: 50
    end

    click_button "Guardar"

    expect(page).to have_content "La encuesta se ha creado exitosamente."
    expect(page).to have_content "2 preguntas"
    expect(current_path).to eq admins_service_surveys_path
  end

  scenario 'But fails because of validations', js: true do
    service = create :service, name: "Mi servicio", service_admin: admin

    visit admins_dashboards_path
    click_link "Encuestas de servicio"
    click_link "Crear nueva encuesta"

    check "service_survey_service_ids_#{service.id}"
    click_link "Agregar pregunta"

    select "Desempeño", from: "Criterio a evaluar"

    click_link "Agregar pregunta"
    within all(".nested-fields")[1] do
      select "Seleccionar de 5 posibles en un rango", from: "Tipo de respuesta"
      fill_in "Valor %", with: 20
    end

    click_button "Guardar"

    expect(page).not_to have_content "La encuesta se ha creado exitosamente."
    expect(page).not_to have_content "1 pregunta"
    expect(page).to have_content "Preguntas con valor deben sumar 100% y actualmente suman: 20.0%"
    expect(page).to have_content "Etapa de la encuesta no puede estar en blanco"
  end

  scenario 'and select question text and answer type from previous questions box', js: true do
    questions = create_list(:question, 2, :binary)

    visit new_admins_service_survey_path
    click_link "Agregar pregunta"

    select "Transparencia", from: "Criterio a evaluar"

    expect(page).to have_content questions.first.text
    expect(page).to have_content questions.second.text

    select_question_text questions.first
    sleep 1.0
    expect(page).to have_field "Texto", with: questions.first.text

    select_question_text questions.second
    expect(page).to have_field "Texto", with: questions.second.text
  end

  def select_question_text(question)
    find("li", text: question.text).click()
  end

  def custom_answers_count
    custom_answers.count
  end

  def custom_answers
    all(".custom-answer")
  end

  def fill_custom_answer(index, text)
    custom_answers[index-1].set text
  end
end