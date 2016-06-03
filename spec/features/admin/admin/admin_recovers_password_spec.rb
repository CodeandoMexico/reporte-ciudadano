require 'spec_helper'

feature 'As an admin I can recover my password' do

  let(:admin) { create(:admin) }

  scenario 'before I log in' do
    visit new_admin_session_path

    click_link "Olvidé mi contraseña"
    fill_in "admin[email]", with: admin.email
    click_button "Enviar instrucciones"

    expect_instructions_email_sent_to admin.email
    visit_change_password_email_link

    fill_in "admin[password]", with: "newpassword"
    fill_in "admin[password_confirmation]", with: "newpassword"
    click_button "Cambiar contraseña"
    click_link "Cerrar sesión"

    sign_in_admin(admin, password: "newpassword")
    expect(current_path).to eq admins_dashboards_path
  end

  def expect_instructions_email_sent_to(email)
    expect(last_email.to).to include(email)
    expect(last_email.subject).to include "Instrucciones para recuperar contraseña"
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def visit_change_password_email_link
    link = Capybara.string(last_email.body.encoded).find("a.change-password")
    visit link[:href]
  end
end