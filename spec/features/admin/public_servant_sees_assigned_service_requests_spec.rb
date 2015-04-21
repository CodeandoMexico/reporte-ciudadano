require 'spec_helper'

feature 'As a public servant I can see every service request from assigned service' do

  let(:admin) { create(:admin, :public_servant, dependency: "Dependencia 1") }

  background do
    sign_in_admin admin
  end

  scenario 'I can see a list of service requests' do
    service = create :service, name: "Mi servicio"
    service_requests = create_list(:service_request, 3, service: service)
    given_service_assigned_to(admin, service)

    click_link "Reportes"
    click_link "Mi servicio"

    expect(page).to have_content service.name
    expect(services_request_count).to eq 3
  end

  scenario 'Unless the service was not assigned to me' do
    service = create :service, name: "Otro servicio"
    service_requests = create_list(:service_request, 3, service: service)

    click_link "Reportes"
    expect(page).not_to have_link "Otro servicio"

    visit admins_service_path(service)
    expect(current_path).to eq admins_dashboards_path
    expect(services_request_count).to eq 0
  end

  scenario 'I can see a service request' do
    service = create :service, name: "Mi servicio"
    service_requests = create(:service_request, service: service)
    given_service_assigned_to(admin, service)

    click_link "Reportes"
    click_link "Mi servicio"

    within '.service_request' do
      click_link "Mi servicio"
    end

    expect(current_path).to eq edit_admins_service_request_path(service)
    expect(page).to have_content "Votos"
    expect(page).to have_content "Actualizar reporte"
  end

  def given_service_assigned_to(admin, service)
    admin.update_attributes(service_id: service.id)
    admin.reload
  end

  def services_request_count
    all("tr.service_request").size
  end
end