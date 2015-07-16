require 'spec_helper'

feature 'As an admin I can manage service requests' do

  let(:admin) {create(:admin)}
  let!(:service_request) {create(:service_request)}

  background do
    sign_in_admin admin
  end

  scenario 'I can see the service requests index list' do
    service_requests = create_list(:service_request, 3)
    within '.sidebar-nav' do
      click_link t('admins.shared.sidebar.requests')
    end
    expect(current_path).to eq admins_service_requests_path
    expect(page).to have_content service_requests.first.service.name
    expect(page).to have_content service_requests[1].service.name
    expect(page).to have_content service_requests.last.service.name
  end

  scenario 'I can go to admin view for a service request' do
    visit admins_service_requests_path
    click_link service_request.service.name

    expect(current_path).to eq edit_admins_service_request_path(service_request)
    expect(page).to have_content service_request.service.name
    expect(page).to have_content service_request.status
  end

#el admin ya no crea denuncias
  scenario 'I can create a service request' do
    # first_service = create :service, name: 'my srv'
    # public_servant = create :admin, :public_servant, services: [first_service]
    # visit new_admins_service_request_path

    # select first_service.name, from: 'service_request[service_id]'
    # save_and_open_page
    # #fill_in 'service_request[address]', with: 'An address #111'
    # fill_in 'service_request[description]', with: 'Request description'
    # choose cis
    # click_button t('save')

    # expect_service_request_email_sent_to public_servant.email
    # expect(page).to have_content t('flash.service_requests.created')
    # expect(page).to have_content 'Request description'
    # expect(page).to have_content cis
  end

  scenario 'I can see the service extra fields when creating a request', js: true do
    services = create_list(:service, 2)
    first_service = services.first

    given_service_with_extra_fields(first_service)
    visit new_admins_service_request_path
    #save_and_open_page
    select first_service.name, from: 'service_request[service_id]'

    expect(page).to have_content "Field one"
    expect(page).to have_content "Field two"
  end

  scenario 'I can see the requester full name and email' do
    visit admins_service_requests_path
    click_link service_request.service.name

    expect(current_path).to eq edit_admins_service_request_path(service_request)
    #expect(page).to have_content service_request.requester.name
    expect(page).to have_content service_request.requester.email
    expect(page).to have_content service_request.requester.id
  end

  scenario 'I can update the status of a service request' do
    statuses = create_list(:status, 2)
    visit edit_admins_service_request_path(service_request)
    within '.edit_service_request' do
      select statuses.first.name, from: 'service_request[status_id]'
    end
    click_button t('update')
    expect(page).to have_content t('admins.service_requests.edit.status', status: statuses.first.name)
  end

  scenario 'I can update the service of a service request' do
    services = create_list(:service, 2)
    visit edit_admins_service_request_path(service_request)
    within '.edit_service_request' do
      select services.last.name, from: 'service_request[service_id]'
    end
    click_button t('update')
    expect(current_path).to eq edit_admins_service_request_path(service_request)
    expect(page).to have_content services.last.name
  end

  scenario 'I can update the message of a service request', js: true do
    message = create(:message, service: service_request.service, status: service_request.status)
    visit edit_admins_service_request_path(service_request)
    within '.edit_service_request' do
      select message.status.name, from: 'service_request[status_id]'
      choose "message"
    end
    click_button 'Actualizar'

    within '.stream' do
      # Message content should be posted as a comment on the service request
      expect(page).to have_content message.content
    end
  end

  scenario 'I can delete a service request' do
    visit admins_service_requests_path
    page.find("a[href='#{admins_service_request_path(service_request)}']").click
    expect(page).to have_content t('flash.service_requests.destroyed')
  end

  scenario 'I can post a comment on a service request' do
    visit edit_admins_service_request_path(service_request)
    within '#new_comment' do
      fill_in 'comment[content]', with: 'Reporte ciudadano es lo mejor'
      attach_file 'comment[image]', File.join(Rails.root, '/spec/support/features/images/avatar.png')
      click_button 'Comentar'
    end

    expect(page).to have_content 'Reporte ciudadano es lo mejor'
    expect(page).to have_content 'Tu comentario ha sido publicado'
  end

  scenario 'I can delete a comment on a service request' do
    comment = create(:comment, service_request: service_request)
    visit edit_admins_service_request_path(service_request)
    page.find("a[href='#{comment_path(comment)}']").click
    expect(page).not_to have_content comment.content
  end

  def given_service_with_extra_fields(service)
    create :service_field, name: "field one", service: service
    create :service_field, name: "field two", service: service
  end

  def expect_service_request_email_sent_to(email)
    last_email = ActionMailer::Base.deliveries.last || :no_email_sent
    expect(last_email.to).to include(email)
    expect(last_email.subject).to include "Nuevo reporte de servicio"
  end
end
