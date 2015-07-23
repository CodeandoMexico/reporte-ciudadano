require 'spec_helper'

feature 'As a service admin I can see managed services' do

  let(:admin) { create(:admin, :service_admin) }

  background do
    sign_in_admin admin
  end

  scenario 'I can see the dashboard with my services' do
    unmanaged_service = create :service
    managed_services = create_list(:service, 2, service_admin_id: admin.id)

    visit admins_dashboards_path
    click_link "Trámites"

    expect(page).to have_content managed_services.first.name
    expect(page).to have_content managed_services.last.name
    expect(page).not_to have_content unmanaged_service.name
  end
end