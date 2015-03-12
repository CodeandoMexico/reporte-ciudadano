require "spec_helper"

feature 'As an admin I can upload organization logos' do

  let(:admin) { create(:admin) }

  background do
    sign_in_admin admin
    click_link t('navbar.admin.design')
  end

  scenario 'I can visit the upload logos view' do
    page.find("a[href='#{new_admins_logo_path}']").click
    expect(page).to have_content "Agregar nuevo logo"
  end

end
