require 'spec_helper'

feature 'As a service admin I can disable a public servant' do

  let(:admin) { create(:admin, :service_admin) }

  background do
    sign_in_admin admin
  end

  scenario 'I can edit a service admin', js: true do
    public_servants = create_list(:admin, 3, :public_servant)
    first_public_servant = public_servants.first

    visit admins_public_servants_path
    click_disable_link_for first_public_servant
    confirm_dialog

    expect(page).to have_content "El servidor público se ha desactivado exitosamente"
    expect(page).not_to have_content first_public_servant.name
  end

  def click_disable_link_for(public_servant)
    find("a#disable_public_servant_#{public_servant.id}").click
  end

  def confirm_dialog
    page.driver.browser.switch_to.alert.accept
  end
end