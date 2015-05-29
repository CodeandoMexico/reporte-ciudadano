require 'spec_helper'

feature 'As a service admin I can see a survey preview' do

  let(:admin) { create(:admin, :service_admin) }

  background do
    sign_in_admin admin
  end

  scenario 'from surveys index page' do
    service = create :service, name: "Mi servicio", service_admin: admin

    binary_questions = create_list(:question, 2, :binary)
    rating_questions = create_list(:question, 2, :rating, value: 50.0)

    service_survey = create :service_survey, title: "Mi encuesta", services: [service], questions: binary_questions + rating_questions, admin_id: admin.id

    visit admins_dashboards_path
    click_link "Encuestas de servicio"

    expect(page).to have_content "Mi encuesta"
    expect(page).to have_content "4 preguntas"

    click_link "Mi encuesta"

    expect(page).to have_content "Encuesta para evaluar los servicios: #{service.name}"
    expect(page).to have_content "Sí"
    expect(page).to have_content "No"
    expect(page).to have_content "Muy bueno"
    expect(page).to have_content "Muy malo"
    expect(page).to have_link "Editar encuesta"
    expect(questions_number).to eq 4
  end

  def questions_number
    all(".question").count
  end
end