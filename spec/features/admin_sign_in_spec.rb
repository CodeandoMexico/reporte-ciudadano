require 'spec_helper'

feature 'Admin signs in and sign out' do

  let(:admin) { create(:admin) }

  scenario 'with valid email and password' do
    sign_in_admin admin

    current_path.should == admins_categories_path
  end

  scenario 'with invalid email and password' do
    sign_in_admin admin, password: 'invalid'

    current_path.should == new_admin_session_path
    page.should have_content "Correo o contraseña inválidos"
  end

end
