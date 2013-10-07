module SessionHelpers

  def sign_in_admin(admin, opts={})
    visit new_admin_session_path
    fill_in 'admin[email]',    with: admin.email
    fill_in 'admin[password]', with: opts[:password] || admin.password
    click_button 'Registro'
  end

end
