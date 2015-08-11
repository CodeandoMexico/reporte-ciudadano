require 'spec_helper'

feature 'As an admin I can create new service admins' do

  let(:admin) { create(:admin) }

  background do
    sign_in_admin admin
  end

  scenario 'I can see a list of service admins' do
    service_admins = create_list(:admin, 3, :service_admin)

    visit admins_dashboards_path
    click_link "Administradores"

    expect(page).to have_content service_admins.first.name
    expect(service_admins_count).to eq 3
  end

  scenario 'I can create a new service admin with valid data' do
    services = create_list(:service, 2)
    last_service = services.last

    visit admins_service_admins_path
    click_link "Agregar administrador"

    fill_in "admin[name]", with: "María Gómez"
    fill_in "admin[email]", with: "maria@mail.com"
    fill_in "admin[record_number]", with: "Ma01"
    select dependency, from: "admin[dependency]"
    select administrative_unit, from: "admin[administrative_unit]"
    fill_in "admin[charge]", with: "Director"
    check "admin_services_ids_2"

    click_button "Guardar"

    expect(page).to have_content "El administrador de trámites se ha registrado exitosamente."
    expect(current_path).to eq admins_service_admins_path
    expect(page).to have_content "María Gómez"
    expect_mail_sent_to "maria@mail.com"
  end

  scenario 'And only as a super admin' do
    service_admin = create :admin, :service_admin

    click_link "Cerrar sesión"
    sign_in_admin service_admin
    expect(page).not_to have_link "Administradores"

    visit new_admins_service_admin_path
    expect(current_path).to eq admins_dashboards_path
  end

  def expect_mail_sent_to(email)
    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.to).to include(email)
    expect(last_email.subject).to include "Bienvenido a"
  end

  def service_admins_count
    all(:css, ".service_admin").size
  end
end
