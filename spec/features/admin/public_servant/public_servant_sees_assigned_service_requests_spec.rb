require 'spec_helper'

feature 'As a public servant I can see every service request from assigned service' do

  let(:admin) { create(:admin, :public_servant, dependency: "Dependencia 1") }

  scenario 'I can see a list of service requests' do
    service = create :service, name: "Mi servicio"
    service_requests = create_list(:service_request, 3, service: service)
    given_services_assigned_to(admin, [service])
    sign_in_admin admin

    within '.sidebar-nav' do
      click_link "Quejas o sugerencias"
      click_link "Mi servicio"
    end

    expect(page).to have_content service.name
  end

  scenario 'Unless the service was not assigned to me' do
    service = create :service, name: "Otro servicio"
    service_requests = create_list(:service_request, 3, service: service)

    sign_in_admin admin

    within '.sidebar-nav' do
      click_link "Quejas o sugerencias"
      expect(page).not_to have_link "Otro servicio"
    end

    visit admins_service_path(service)
    expect(current_path).to eq admins_service_requests_path
    expect(services_request_count).to eq 0
  end


  def given_services_assigned_to(admin, services)
    admin.services = services
    admin.save
  end

  def services_request_count
    all("tr.service_request").size
  end
end