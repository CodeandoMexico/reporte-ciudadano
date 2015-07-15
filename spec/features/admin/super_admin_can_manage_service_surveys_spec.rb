require 'spec_helper'

feature 'As a super admin I can manage service surveys' do

  let(:admin) { create(:admin) }

  background do
    sign_in_admin admin
  end

  scenario 'Assigned to every service' do
    service = create :service, name: "Servicio"
    surveys = create_list(:survey_with_binary_question, 2, services: [service])

    visit admins_dashboards_path
    click_link "Encuestas de servicio"
    expect(surveys_count).to eq 2
    expect(current_path).to eq admins_service_surveys_path

    click_link "Crear nueva encuesta"
    expect(current_path).to eq new_admins_service_survey_path
  end

  def surveys_count
    all(".service-survey").size
  end
end