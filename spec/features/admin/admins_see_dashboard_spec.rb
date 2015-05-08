require 'spec_helper'

feature 'Admins see dashboard' do

  let(:all_services) { create_list(:service, 3) }
  let(:super_admin) { create(:admin) }
  let(:service_admin) { create(:admin, :service_admin) }
  let(:public_servant) { create(:admin, :public_servant) }

  scenario 'as service admin' do
    sign_in_admin service_admin
    given_admin_manages(all_services.first, service_admin)

    expect(current_path).to eq admins_dashboards_path
    expect(page).to have_content all_services.first.name
    expect(page).not_to have_content all_services.second.name
    expect(page).not_to have_content all_services.last.name

    within ".highcharts-container" do
      expect(page).to have_content all_services.first.name
    end

    expect(services_request_count).to eq 1
  end

  def given_admin_manages(service, admin)
    service.update_attributes(admin_id: admin.id)
  end

  def services_request_count
    all("tr.service_request").size
  end
end