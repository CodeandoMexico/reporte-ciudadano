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
