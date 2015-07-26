require 'spec_helper'

feature 'Admins see dashboard' do

  let(:super_admin) { create(:admin) }
  let(:service_admin) { create(:admin, :service_admin) }
  let(:public_servant) { create(:admin, :public_servant) }

  scenario 'as super admin', js: true do
    all_service_requests = create_list(:service_request, 3, service: create(:service))

    sign_in_admin super_admin
    expect(current_path).to eq admins_dashboards_path

    all_service_requests.each do |request|
      expect(page).to have_content request.service.name

      within ".highcharts-container" do
        expect(page).to have_content request.service.name
      end
    end

    expect(services_request_count).to eq 3
  end

  scenario 'as service admin', js: true do
    first_service_request = create :service_request
    second_service_request = create :service_request, service: first_service_request.service
    third_service_request =  create :service_request

    given_admin_manages(first_service_request.service, service_admin)
    sign_in_admin service_admin

    expect(current_path).to eq admins_dashboards_path

    within ".recent-reports" do
      expect(page).to have_content first_service_request.service.name
      expect(page).to have_content second_service_request.service.name
      expect(page).not_to have_content third_service_request.service.name
    end

    within ".highcharts-container" do
      expect(page).to have_content first_service_request.service.name
      expect(page).to have_content second_service_request.service.name
      expect(page).not_to have_content third_service_request.service.name
    end

    expect(services_request_count).to eq 2
  end

  scenario 'as public servant' do
    first_service_request = create :service_request
    second_service_request = create :service_request, service: first_service_request.service
    third_service_request =  create :service_request

    given_admin_has_assigned(first_service_request.service, public_servant)
    sign_in_admin public_servant

    expect(current_path).to eq admins_service_requests_path

    within '.sortable_table' do
      expect(page).to have_content first_service_request.service.name
      expect(page).to have_content second_service_request.service.name
      expect(page).not_to have_content third_service_request.service.name
    end
  end

  def given_admin_manages(service, admin)
    service.update_attributes(service_admin_id: admin.id)
  end

  def services_request_count
    all(".recent-report-sum").size
  end

  def given_admin_has_assigned(service, admin)
    admin.services = [service]
    admin.save
  end
end