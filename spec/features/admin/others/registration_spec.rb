require 'spec_helper'

feature 'Registration integration' do

  let(:admin) { create(:admin, name: "Super admin", password: "password", password_confirmation: "password") }

  background do
    sign_in_admin admin
  end

  scenario 'As an admin I can see an edit link' do
    visit admins_services_path
    expect(page).to have_content 'Editar perfil'
  end

  scenario 'As an admin I can update my profile' do
    visit edit_admins_registration_path(admin)
    within first('.edit_admin') do
      fill_in 'admin[name]', with:  'Eddie R.'
      attach_file 'admin[avatar]', File.join(Rails.root, '/spec/support/features/images/avatar.png')
      fill_in 'admin[email]', with: 'nuevo@correo.com'
    end
    click_button 'Actualizar'
    expect(page).to have_content 'El perfil fue editado satisfactoriamente.'
  end

  scenario 'As an admin I can change my password', js: true do
    click_link "Super admin"
    click_link "Editar perfil"

    fill_in 'admin[current_password]', with: 'password'
    fill_in 'admin[password]', with:  'newpassword'
    fill_in 'admin[password_confirmation]', with:  'newpassword'
    click_button 'Cambiar contraseña'

    expect(page).to have_content "La contraseña se ha actualizado con éxito."
  end
end
