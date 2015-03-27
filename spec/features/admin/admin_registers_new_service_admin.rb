require 'spec_helper'

feature 'As an admin I can create new service admins' do

  let(:admin) { create(:admin) }

  background do
    sign_in_admin admin
  end

  scenario 'I can see a list of service admins' do
    #services = create_list(:service, 3)
    service_admins = create_list(:admin, 3, :service_admin)

    visit admins_dashboards_path
    click_link "Administradores"

    expect(page).to have_content service_admins.first.name
    expect(service_admins_count).to eq 3
  end

  def service_admins_count
    all(:css, ".service_admin").size
  end
end
