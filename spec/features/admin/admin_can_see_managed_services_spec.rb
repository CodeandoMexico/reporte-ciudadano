require 'spec_helper'

feature 'As a super admin I can see every service' do

  let(:admin) { create(:admin) }

  background do
    sign_in_admin admin
  end

  scenario 'I can see the dashboard with all services' do
    services = create_list(:service, 2)
    save_and_open_page
    visit admins_dashboards_path
    click_link "Trámites"

    expect(page).to have_content services.first.name
    expect(page).to have_content services.last.name
  end
end