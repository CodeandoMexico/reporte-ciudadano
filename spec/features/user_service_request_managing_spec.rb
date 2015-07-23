require 'spec_helper'
require 'active_support/core_ext/string/filters'

feature 'Managing service requests' do

  let(:user) { create(:user) }
  let(:service_request) { create(:service_request, requester: user) }

  context 'when not logged in user' do
    scenario 'get redirected to sign in page after trying to go to create a new service request' do
      visit new_service_request_path
      expect(current_url).to eq new_user_session_url
    end

    scenario 'can see a list of service requests' do
      service_requests = create_list(:service_request, 2)
      visit service_requests_path
      expect(page).to have_content service_requests.first.description.truncate(30)
      expect(page).to have_content service_requests.last.description.truncate(30)
    end

    scenario 'can search for service requests by min creation date' do
      service_requests = []
      service_requests << create(:service_request, created_at: 10.days.ago)
      service_requests << create(:service_request, created_at: 5.days.ago)
      service_requests << create(:service_request, created_at: 3.days.ago)
      visit service_requests_path
      within '#service_request_search' do
        fill_in 'q[date_gteq]', with: 3.days.ago.strftime("%Y-%m-%d").to_s
        click_button 'Buscar'
      end
      expect(page).to have_content service_requests.last.description.truncate(30)
      expect(page).not_to have_content service_requests.first.description.truncate(30)
      expect(page).not_to have_content service_requests[1].description.truncate(30)
    end

    scenario 'can search for service requests by max creation date' do
      service_requests = []
      service_requests << create(:service_request, created_at: 10.days.ago)
      service_requests << create(:service_request, created_at: 5.days.ago)
      service_requests << create(:service_request, created_at: 3.days.ago)
      visit service_requests_path
      within '#service_request_search' do
        fill_in 'q[date_lteq]', with: 4.days.ago.strftime("%Y-%m-%d").to_s
        click_button 'Buscar'
      end
      expect(page).not_to have_content service_requests.last.description.truncate(30)
      expect(page).to have_content service_requests.first.description.truncate(30)
      expect(page).to have_content service_requests[1].description.truncate(30)
    end

    scenario 'can search for service requests by service' do
      service_requests = create_list(:service_request, 3)
      first_service = service_requests.first

      visit service_requests_path
      within '#service_request_search' do
        select first_service.service.name, from: 'q[service_id_eq]'
        click_button 'Buscar'
      end
      expect(page).to have_content first_service.description.truncate(30)
      expect(page).not_to have_content service_requests[1].description.truncate(30)
      expect(page).not_to have_content service_requests.last.description.truncate(30)
    end

    scenario 'can search for service requests by status' do
      custom_status = create :status
      service_requests = create_list(:service_request, 3, status: custom_status)
      visit service_requests_path
      within '#service_request_search' do
        select service_requests.first.status.name, from: 'q[status_id_eq]'
        click_button 'Buscar'
      end
      expect(page).to have_content service_requests.first.description.truncate(30)
      expect(page).to have_content service_requests[1].description.truncate(30)
      expect(page).to have_content service_requests.last.description.truncate(30)
    end

    scenario 'can go see a service request' do
      visit service_request_path(service_request)
      expect(page).to have_content(service_request.service.name)
    end
  end

  context 'when logged in user' do

    background do
      sign_in_user user
    end

    scenario 'can create a new service request successfully' do
      service = create(:service)
      public_servant = create(:admin, :public_servant, services: [service])

      visit new_service_request_path
      within '#new_service_request' do
        attach_file 'service_request[media]', File.join(Rails.root, '/spec/support/features/images/avatar.png')
        fill_in 'service_request[description]', with: 'No water'
        select service.name, from: 'service_request[service_id]'
        click_button  'Guardar'
      end
      expect(page).to have_content '123 Governor Dr, San Diego, CA 92122'
      expect_service_request_email_sent_to public_servant.email
    end


    scenario 'can comment on a service request'  do
      comment_content = 'This is my comment'
      visit service_request_path(service_request)
      within '#new_comment' do
        attach_file 'comment[image]', File.join(Rails.root, '/spec/support/features/images/avatar.png')
        fill_in 'comment[content]', with: comment_content
        click_button  'Comentar'
      end
      expect(current_url).to eq service_request_url(service_request)
      expect(page).to have_content(comment_content)
      expect(page).to have_xpath("//img[@src=\"/uploads/comment/image/1/comment_avatar.png\"]")
    end

    def expect_service_request_email_sent_to(email)
      last_email = ActionMailer::Base.deliveries.last || :no_email_sent
      expect(last_email.to).to include(email)
      expect(last_email.subject).to include "Nuevo reporte de servicio"
    end
  end
end
