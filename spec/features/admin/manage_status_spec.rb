require 'spec_helper'

feature 'Managing statuses' do

  let(:admin) { create(:admin) }

  background do
    sign_in_admin admin
  end

  scenario 'As an admin I can create a new status' do
    visit admins_services_path
    click_link t('admins.services.index.new_status')
    within '#new_status' do
      fill_in 'status[name]', with: 'Open'
      click_button t('save')
    end

    page.should have_content t('flash.status.created')

  end

  scenario 'As an admin I can edit a status' do
    status = create(:status)
    visit edit_admins_status_path(status)
    fill_in 'status[name]', with: 'Open'
    click_button t('save')

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
