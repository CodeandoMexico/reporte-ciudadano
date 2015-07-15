require 'spec_helper'

feature 'As a service admin I can see managed service requests' do

  let(:admin) { create(:admin, :service_admin) }

  background do
    sign_in_admin admin
  end

  scenario 'I can see the dashboard with every service request' do
    managed_services = create_list(:service, 2, service_admin_id: admin.id)
    given_service_has_info(managed_services.first, name: "Primer servicio", requests: 2)
    given_service_has_info(managed_services.last, name: "Segundo servicio", requests: 3)

    visit admins_dashboards_path

    within "#sidebar-wrapper" do
      click_link "Quejas o sugerencias"
      click_link "Primer servicio"
    end

    expect(page).to have_content "Primer servicio"
    #expect(services_request_count).to eq 2

    within "#sidebar-wrapper" do
      click_link "Quejas o sugerencias"
      click_link "Segundo servicio"
    end

    expect(page).to have_content "Segundo servicio"
    #expect(services_request_count).to eq 3
  end

  scenario 'Unless I have no services assigned' do
    visit admins_dashboards_path

    within "#sidebar-wrapper" do
      click_link "Quejas o sugerencias"
    end

    expect(page).to have_content "No tiene trámites asignados"
  end

  def given_service_has_info(service, info)
    service.name = info[:name]
    service.service_requests = create_list(:service_request, info[:requests], service: service)
    service.save
  end

  def services_request_count
    all("tr.service_request").size
  end
end