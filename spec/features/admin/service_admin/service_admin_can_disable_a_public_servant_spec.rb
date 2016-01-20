require 'spec_helper'

feature 'As a service admin I can disable a public servant' do

  let(:admin) { create(:admin, :service_admin, dependency: "A dependency") }

  background do
    sign_in_admin admin
  end

  scenario 'I can disable a public servant from list', js: true do
    public_servants = create_list(:admin, 3, :public_servant, dependency: admin.dependency)
    first_public_servant = public_servants.first

    visit admins_public_servants_path
    click_disable_link_for first_public_servant
    confirm_dialog

    expect(page).to have_content "El servidor público se ha desactivado exitosamente"
    click_link "Inactivos"
    expect(page).to have_content first_public_servant.name

    click_link "Activos"
    expect(find('.tab-content>.tab-pane#enabled')).not_to have_content first_public_servant.name
  end

  scenario 'I can enable a disabled public servant', js: true do
    public_servant = create :admin, :public_servant, dependency: admin.dependency, disabled: true

    visit admins_public_servants_path

    click_link "Inactivos"
    click_enable_link_for public_servant
    confirm_dialog

    expect(page).to have_content "El servidor público se ha activado exitosamente"
    expect(page).to have_content public_servant.name

    click_link "Inactivos"
    expect(find('.tab-content>.tab-pane#disabled')).not_to have_content public_servant.name
  end

  def click_disable_link_for(public_servant)
    find("a#disable_public_servant_#{public_servant.id}").click
  end

  def click_enable_link_for(public_servant)
    find("a#enable_public_servant_#{public_servant.id}").click
  end

  def confirm_dialog
    page.driver.browser.switch_to.alert.accept
  end
end