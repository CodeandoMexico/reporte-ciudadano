require 'spec_helper'

feature 'As an admin I can manage service requests' do

  let(:admin) {create(:admin)}
  let!(:service_request) {create(:service_request)}

  background do
    sign_in_admin admin
  end

  scenario 'I can see a the service requests index list' do
    service_requests = create_list(:service_request, 3)
    within '.sidebar-nav' do
      click_link 'Solicitudes'
    end
    current_path == admins_service_requests_path
    page.should have_content service_requests.first.service.name
    page.should have_content service_requests[1].service.name
    page.should have_content service_requests.last.service.name
  end

  scenario 'I can go to admin view for a service request' do
    visit admins_service_requests_path
    click_link service_request.service.name

    current_path == edit_admins_service_request_path(service_request)
    page.should have_content service_request.service.name
    page.should have_content service_request.status
  end

  scenario 'I can see the requester full name and email' do
    visit admins_service_requests_path
    click_link service_request.service.name

    current_path == edit_admins_service_request_path(service_request)
    page.should have_content service_request.requester.name
    page.should have_content service_request.requester.email
    page.should have_content service_request.requester.id
  end

  scenario 'I can update the status of a service request' do
    statuses = create_list(:status, 2)
    visit edit_admins_service_request_path(service_request)
    within '.edit_service_request' do
      select statuses.first.name, from: 'service_request[status_id]'
    end
    click_button 'Actualizar'
    page.should have_content "Status: #{statuses.first.name}"
  end

  scenario 'I can update the service of a service request' do
    services = create_list(:service, 2)
    visit edit_admins_service_request_path(service_request)
    within '.edit_service_request' do
      select services.last.name, from: 'service_request[service_id]'
    end
    click_button 'Actualizar'
    current_path.should == edit_admins_service_request_path(service_request)
    page.should have_content services.last.name
  end

  scenario 'I can delete a service request' do
    visit service_requests_path
    page.find("a[href='#{admins_service_request_path(service_request)}']").click
    page.should have_content 'La solicitud fue eliminada correctamente'
  end

end
