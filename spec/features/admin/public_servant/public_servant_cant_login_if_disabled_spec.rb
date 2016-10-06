require 'spec_helper'

feature 'As a disabled public servant I can not log in' do

  let(:disabled_admin) { create(:admin, :public_servant, disabled: true) }

  scenario 'I can disable a public servant from list', js: true do
    visit new_admin_session_path
    fill_in 'admin[email]', with: disabled_admin.email
    fill_in 'admin[password]', with: disabled_admin.password
    click_button 'Entrar'

    expect(page).to have_content "Tu cuenta ha sido desactivada, por favor contacta a tu Administrador."
  end
end