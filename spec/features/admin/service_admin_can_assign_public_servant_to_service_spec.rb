require 'spec_helper'

feature 'As a service admin I can assign a public servant to a service' do

  let(:admin) { create(:admin, :service_admin) }

  background do
    sign_in_admin admin
  end

  scenario 'I can assign a public servant' do
    public_servant = create :admin, :public_servant
    unassigned_service = create :service, name: "Fuga", service_admin_id: admin.id
    other_unassigned_service = create :service, name: "Tubería rota", service_admin_id: admin.id

    visit admins_dashboards_path
    click_link "Servidores públicos"
    click_link "Asignar trámites"

    expect(page).to have_content unassigned_service.name
    expect(page).to have_content other_unassigned_service.name

    check "admin_services_ids_#{unassigned_service.id}"
    click_button "Asignar"

    expect(page).to have_content "Fuga"
    expect(current_path).to eq admins_public_servants_path

    click_link "Asignar trámites"

    expect(checkbox(unassigned_service)).to be_checked
    expect(checkbox(other_unassigned_service)).not_to be_checked
  end

  scenario 'I can remove service assignation for a public servant' do
    public_servant = create :admin, :public_servant
    assigned_service = create :service, name: "Fuga", service_admin_id: admin.id, admins: [public_servant]

    visit admins_dashboards_path
    click_link "Servidores públicos"
    click_link "Asignar trámites"

    uncheck "admin_services_ids_#{assigned_service.id}"
    click_button "Asignar"

    within first(".public_servant") do
      expect(page).not_to have_content "Fuga"
      expect(current_path).to eq admins_public_servants_path
    end

    click_link "Asignar trámites"
    expect(checkbox(assigned_service)).not_to be_checked
  end

  def checkbox(service)
    find("#admin_services_ids_#{service.id}")
  end
end