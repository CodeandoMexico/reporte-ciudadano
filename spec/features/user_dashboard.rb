require 'spec_helper'

feature 'When I am in the dashboard' do

  context 'as a logged in user' do
    let(:user) { create(:user)}
    let!(:reports) {create_list(:report, 3)}

    background do
      sign_in_user user
    end

    scenario 'I can vote on an report', js: true do
      visit root_path
      save_and_open_page
      page.find("a[href='/reports/#{reports.first.id}/vote']").click
      page.should have_content('Votaste')
    end

  end

end
