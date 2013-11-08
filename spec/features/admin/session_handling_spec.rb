require 'spec_helper'

feature 'Admin session handling' do

  let(:admin) { create(:admin) }

  scenario 'signs in with valid email and password' do
    sign_in_admin admin

    current_path.should == admins_services_path
  end

  scenario 'cannot sign in with invalid email and password' do
    sign_in_admin admin, password: 'invalid'

    current_path.should == new_admin_session_path
    page.should have_content "Correo o contraseña inválidos"
  end

  scenario 'signs out and is redirected to the root page' do
    sign_in_admin admin
    page.find('a[href="/admins/sign_out"]').click
    page.should have_content 'Iniciar sesión'
    current_url.should eq root_url
  end

end
