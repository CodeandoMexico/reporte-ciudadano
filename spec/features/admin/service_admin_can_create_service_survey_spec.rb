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
end