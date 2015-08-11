require 'spec_helper'

feature 'As an admin I can edit a service admin' do

  let(:admin) { create(:admin) }

  background do
    sign_in_admin admin
  end

  scenario 'I can edit a service admin' do
    service_admins = create_list(:admin, 3, :service_admin)
    services = create_list(:service, 2)
    first_service_admin = service_admins.first

    visit admins_dashboards_path
    click_link "Administradores"
    click_edit_link_for first_service_admin

    expect(find_field('admin[name]').value).to eq first_service_admin.name

    fill_in "admin[name]", with: "New name"
    select dependency, from: "admin[dependency]"
    select administrative_unit, from: "admin[administrative_unit]"
    check "admin_services_ids_#{services.first.id}"
    click_button "Actualizar"

    expect(page).to have_content "El administrador de trámites se ha actualizado exitosamente"
    expect(page).to have_content "New name"
    expect(page).to have_content dependency
    expect(page).to have_content administrative_unit

    click_edit_link_for first_service_admin
    expect(service_checkbox(services.first)).to be_checked
    expect(service_checkbox(services.last)).not_to be_checked
  end

  def service_checkbox(service)
    find("input[type='checkbox']#admin_services_ids_#{service.id}")
  end

  def click_edit_link_for(service_admin)
    find("a#edit_service_admin_#{service_admin.id}").click
  end
end