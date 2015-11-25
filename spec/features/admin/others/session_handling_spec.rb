require 'spec_helper'

feature 'Admin session handling' do

  let(:admin) { create(:admin) }

  scenario 'signs in with valid email and password' do
    sign_in_admin admin

    expect(current_path).to eq admins_dashboards_path
  end

  scenario 'cannot sign in with invalid email and password' do
    sign_in_admin admin, password: 'invalid'

    expect(current_path).to eq new_admin_session_path
    expect(page).to have_content "Correo o contraseña inválidos"
  end

  scenario 'signs out and is redirected to the root page' do
    sign_in_admin admin
    page.find("a[href=\"#{destroy_admin_session_path}\"]").click
    expect(page).to have_content 'Iniciar sesión'
    expect(current_url).to eq root_url
  end
end
