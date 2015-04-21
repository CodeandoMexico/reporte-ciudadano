require 'spec_helper'

feature 'As a service admin I can assign a public servant to a service' do

  let(:admin) { create(:admin, :service_admin) }

  background do
    sign_in_admin admin
  end

  scenario 'I can assign a public servant' do
    public_servant = create :admin, :public_servant
    unassigned_service = create :service, name: "Fuga", admin_id: admin.id

    visit admins_dashboards_path
    click_link "Servidores Públicos"
    click_button "Asignar servicio"

    select "Fuga", from: "admin[service_id]"
    click_button "Asignar"

    expect(page).to have_content "Fuga"
    expect(page).not_to have_button "Asignar servicio"
    expect(current_path).to eq admins_public_servants_path
  end
end