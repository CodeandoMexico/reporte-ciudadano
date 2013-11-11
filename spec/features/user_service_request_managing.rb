require 'spec_helper'
require 'active_support/core_ext/string/filters'

feature 'Managing service requests' do

  let(:user) { create(:user) }
  let(:service_request) { create(:service_request, service_requestable: user) }

  context 'when not logged in user' do
    scenario 'get redirected to sign in page after trying to go to create a new service request' do
      visit new_service_request_path
      current_url.should eq new_user_session_url
    end

    scenario 'can see a list of service requests' do
      service_requests = create_list(:service_request, 2)
      visit service_requests_path
      page.should have_content service_requests.first.description.truncate(30)
      page.should have_content service_requests.last.description.truncate(30)
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
      page.should have_content service_requests.last.description.truncate(30)
      page.should_not have_content service_requests.first.description.truncate(30)
      page.should_not have_content service_requests[1].description.truncate(30)
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
      page.should_not have_content service_requests.last.description.truncate(30)
      page.should have_content service_requests.first.description.truncate(30)
      page.should have_content service_requests[1].description.truncate(30)
    end

    scenario 'can search for service requests by service' do
      service_requests = create_list(:service_request, 3)
      visit service_requests_path
      within '#service_request_search' do
        select service_requests.first.service.name, from: 'q[service_id_eq]'
        click_button 'Buscar'
      end
      page.should have_content service_requests.first.description.truncate(30)
      page.should_not have_content service_requests[1].description.truncate(30)
      page.should_not have_content service_requests.last.description.truncate(30)
    end

    scenario 'can search for service requests by status' do
      service_requests = create_list(:service_request, 3)
      visit service_requests_path
      within '#service_request_search' do
        select service_requests.first.status.name, from: 'q[status_id_eq]'
        click_button 'Buscar'
      end
      page.should have_content service_requests.first.description.truncate(30)
      page.should_not have_content service_requests[1].description.truncate(30)
      page.should_not have_content service_requests.last.description.truncate(30)
    end

    scenario 'can go see a service request' do
      visit service_request_path(service_request)
      page.should have_content(service_request.service.name)
    end


  end

  context 'when logged in user' do

    background do
      sign_in_user user
    end

    scenario 'can create a new service request successfully' do
      categories = create_list(:service, 3)
      visit new_service_request_path
      within '#new_service_request' do
        attach_file 'service_request[image]', File.join(Rails.root, '/spec/support/features/images/avatar.png')
        fill_in 'service_request[address]', with: '123 Governor Dr, San Diego, CA 92122'
        fill_in 'service_request[description]', with: 'No water'
        select categories.last.name, from: 'service_request[service_id]'
        click_button  'Guardar'
      end
      current_url.should eq root_url
      page.should have_content '123 Governor Dr, San Diego, CA 92122'
    end

    scenario 'can vote on an service request', js: true do
      visit service_request_path(service_request)
      page.find("a[href='/service_requests/#{service_request.id}/vote']").click
      page.should have_content('Votaste')
    end

    scenario 'can comment on a service request'  do
      comment_content = 'This is my comment'
      visit service_request_path(service_request)
      within '#new_comment' do
        attach_file 'comment[image]', File.join(Rails.root, '/spec/support/features/images/avatar.png')
        fill_in 'comment[content]', with: comment_content
        click_button  'Comentar'
      end
      current_url.should eq service_request_url(service_request)
      page.should have_content(comment_content)
      page.should have_xpath("//img[@src=\"/uploads/comment/image/1/comment_avatar.png\"]")
    end

  end

end
