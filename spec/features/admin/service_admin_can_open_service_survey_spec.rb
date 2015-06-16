require 'spec_helper'

feature 'As a service admin I can open a survey' do

  let(:admin) { create(:admin, :service_admin) }

  background do
    sign_in_admin admin
  end

  scenario 'from surveys index' do
    service = create :service, name: "Mi servicio", service_admin: admin
    survey = create :survey_with_binary_question, admin: admin, open: false

    visit admins_dashboards_path
    click_link "Encuestas de servicio"
    click_button "Abrir encuesta"

    expect(page).to have_button "Cerrar encuesta"
    click_button "Cerrar encuesta"

    expect(page).to have_button "Abrir encuesta"
  end
end