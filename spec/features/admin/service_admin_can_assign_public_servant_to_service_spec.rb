require 'spec_helper'

feature 'As a service admin I can assign a public servant to a service' do

  let(:admin) { create(:admin, :service_admin) }

  background do
    sign_in_admin admin
  end

  scenario 'I can assign a public servant' do
    public_servant = create :admin, :public_servant
    unassigned_service = create :service, name: "Fuga", admin_id: admin.id
    other_unassigned_service = create :service, name: "Tubería rota", admin_id: admin.id

    visit admins_dashboards_path
    click_link "Servidores Públicos"
    click_link "Asignar servicios"

    expect(page).to have_content unassigned_service.name
    expect(page).to have_content other_unassigned_service.name

    check "admin_services_ids_#{unassigned_service.id}"
    click_button "Asignar"

    expect(page).to have_content "Fuga"
    expect(current_path).to eq admins_public_servants_path

    click_link "Asignar servicios"
    raise public_servant.managed_services.inspect

    expect(checkbox(unassigned_service)).to be_checked
  end

  def checkbox(service)
    find("#admin_services_ids_#{service.id}")
  end
end