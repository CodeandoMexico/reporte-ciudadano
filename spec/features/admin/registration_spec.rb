require 'spec_helper'

feature 'Registration integration' do

  let(:admin) { create(:admin) }

  background do
    sign_in_admin admin
  end

  scenario 'As an admin I can see an edit link' do
    visit admins_services_path
    page.should have_content 'Editar perfil'
  end

  scenario 'As an admin I can update my profile' do
    visit edit_admins_registration_path(admin)
    within '.edit_admin' do
      fill_in 'admin[name]', with:  'Eddie R.'
      attach_file 'admin[avatar]', File.join(Rails.root, '/spec/support/features/images/avatar.png')
      fill_in 'admin[email]', with: 'nuevo@correo.com'
    end
    click_button 'Actualizar'
    page.should have_content t('flash.admin.updated')
  end

end
