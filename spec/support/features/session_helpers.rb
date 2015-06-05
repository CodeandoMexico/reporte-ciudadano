module SessionHelpers

  def sign_in_admin(admin, opts={})
    visit new_admin_session_path
    fill_in 'admin[email]',    with: admin.email
    fill_in 'admin[password]', with: opts[:password] || admin.password
    click_button 'Entrar'
  end

  def sign_in_user(user, opts={})
    visit new_user_session_path
    fill_in 'user[email]',    with: user.email
    fill_in 'user[password]', with: opts[:password] || user.password
    click_button 'Entrar'
  end
end
