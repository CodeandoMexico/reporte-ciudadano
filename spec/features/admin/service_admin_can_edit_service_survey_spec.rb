require 'spec_helper'

feature 'As a service admin I can edit a survey' do

  let(:admin) { create(:admin, :service_admin) }

  background do
    sign_in_admin admin
  end

  scenario 'Assigned to a service', js: true do
    service = create :service, name: "Mi servicio", service_admin: admin
    another_service = create :service, name: "Mi otro servicio", service_admin: admin

    survey = create :survey_with_binary_question, admin: admin, services: [service], title: "Mi encuesta"

    visit admins_dashboards_path
    click_link "Encuestas de servicio"

    within ".surveys-table" do
      click_link "Editar"
    end

    fill_in "service_survey_title", with: "Mi encuesta editada"
    expect(selection_in_select_for(service)).to be_selected
    select_from_chosen_by_css(another_service.name, from: "#service_survey_service_ids")

    expect(questions_count).to eq 1
    click_link "Agregar pregunta"

    within all(".nested-fields")[1] do
      select "Desempeño", from: "Criterio a evaluar"
      fill_in "Texto", with: "¿ Qué tan bueno te pareció el servicio ?"
      select "Seleccionar de 5 posibles en un rango", from: "Tipo de respuesta"
      choose "Muy bueno - Muy malo"
      fill_in "Valor %", with: 80
    end


    within first(".nested-fields") do
      select "Seleccionar de 5 posibles en un rango", from: "Tipo de respuesta"
      fill_in "Valor %", with: 20
    end

    click_button "Guardar"
    expect(page).to have_content "La encuesta se ha actualizado exitosamente."
    expect(page).to have_content "Mi encuesta editada"
    expect(page).to have_content "2 preguntas"

    click_link "Vista preliminar"
    click_link "Editar encuesta"

    expect(current_path).to eq edit_admins_service_survey_path(survey)
    expect(questions_count).to eq 2
  end

  scenario 'And can remove questions', js: true do
    service = create :service, name: "Mi servicio", service_admin: admin
    another_service = create :service, name: "Mi otro servicio", service_admin: admin

    survey = create :survey_with_binary_question, admin: admin, services: [service], title: "Mi encuesta"

    visit admins_dashboards_path
    click_link "Encuestas de servicio"
    within ".surveys-table" do
      click_link "Editar"
    end

    expect(questions_count).to eq 1
    click_link "x"
    click_button "Guardar"

    expect(page).to have_content "0 preguntas"
  end

  def questions_count
    all(".js-question").count
  end

  def selection_in_select_for(service)
    find("#service_survey_service_ids").find(:xpath, "option[@value=#{service.id}]")
  end
end