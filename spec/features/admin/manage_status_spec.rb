require 'spec_helper'

feature 'Managing statuses' do

  let(:admin) { create(:admin) }

  background do
    sign_in_admin admin
  end

  scenario 'As an admin I can create a new status' do
    click_link 'Nuevo estatus'
    within '#new_status' do
      fill_in 'status[name]', with: 'Open'
      click_button 'Guardar'
    end

    page.should have_content t('flash.status.created')

  end

  scenario 'As an admin I can edit a status' do
    status = create(:status)
    visit edit_admins_status_path(status)
    within '.edit_status' do
      fill_in 'status[name]', with: 'Open'
      click_button 'Guardar'
    end

    page.should have_content t('flash.status.updated')

  end

  scenario 'As an admin I can see a list of statuses' do
    first, second, third = create_list(:status, 3)
    visit admins_services_path
    page.should have_content(first.name)
    page.should have_content(second.name)
    page.should have_content(third.name)
  end


end
