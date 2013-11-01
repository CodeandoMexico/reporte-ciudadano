require "spec_helper"

feature 'As an admin I can upload organization logos' do

  let(:admin) { create(:admin) }

  background do
    sign_in_admin admin
    click_link t('navbar.admin.design')
  end

  scenario 'I can visit the upload logos view' do
    click_link 'Agregar logo'

    page.should have_content "Logo 1"
    page.should have_content "Logo 2"
    page.should have_content "Logo 3"
    page.should have_content "Agregar otro logo"
  end

end
