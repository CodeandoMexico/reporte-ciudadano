require 'spec_helper'

feature 'When I am in the dashboard' do

  context 'as a logged in user' do
    let(:user) { create(:user) }
    let!(:service_requests) { create_list(:service_request, 3) }

    background do
      sign_in_user user
    end

    scenario 'I can vote on an service_request', js: true do
      visit root_path
      page.find("a[href='/service_requests/#{service_requests.first.id}/vote']").click
      expect(page).to have_content('Votaste')
    end
  end
end
