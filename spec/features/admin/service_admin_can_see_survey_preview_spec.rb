require 'spec_helper'

feature 'As a service admin I can see a survey preview' do

  let(:admin) { create(:admin, :service_admin) }

  background do
    sign_in_admin admin
  end

  scenario 'from surveys index page' do
    service = create :service, name: "Mi servicio", service_admin: admin

    binary_questions = create_list(:question, 2, :binary, value: 10.0)
    rating_questions = create_list(:question, 2, :rating, value: 40.0)
    open_questions = create_list(:question, 1, :open)
    list_questions = create_list(:question, 1, :list, answers: ["Una respuesta", "Otra respuesta", "", "", ""])

    service_survey = create :service_survey, title: "Mi encuesta", services: [service], questions: binary_questions + rating_questions + open_questions + list_questions, admin_id: admin.id

    visit admins_dashboards_path
    click_link "Encuestas de servicio"

    expect(page).to have_content "Mi encuesta"
    expect(page).to have_content "6 preguntas"

    click_link "Mi encuesta"

    service_survey.questions.each do |question|
      expect(page).to have_content question.text
    end

    expect(page).to have_content "Encuesta para evaluar los trámites: #{service.name}"
    expect(page).to have_content "Sí"
    expect(page).to have_content "No"
    expect(page).to have_content "Muy bueno"
    expect(page).to have_content "Muy malo"
    expect(page).to have_content "Una respuesta"
    expect(page).to have_content "Otra respuesta"
    expect(page).to have_link "Editar encuesta"
    expect(questions_number).to eq 6
  end

  def questions_number
    all(".question").count
  end
end