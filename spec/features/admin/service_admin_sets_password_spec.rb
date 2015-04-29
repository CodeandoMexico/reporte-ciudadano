require 'spec_helper'

feature 'As a service admin I can set my password' do

  let(:admin) { create(:admin, :service_admin, active: false) }

  scenario 'When I have never set my password' do
    visit admins_dashboards_url(admin_email: admin.email, admin_token: admin.authentication_token)

    expect(page).to have_content "Cambiar contraseña"
    expect(current_path).to eq set_password_admins_registration_path(admin)

    fill_in "admin_password", with: "secret123"
    fill_in "admin_password_confirmation", with: "secret123"

    click_button "Cambiar contraseña"
    expect(page).to have_content "El perfil fue editado satisfactoriamente"
    expect(current_path).to eq edit_admins_registration_path(admin)
  end
end