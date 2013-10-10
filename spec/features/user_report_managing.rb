require 'spec_helper'

feature 'Creating report' do

  let(:user) { create(:user) }

  context 'when not logged in user' do
    scenario 'get redirected to sign in page after trying to go to create a new report' do
      visit new_report_path
      current_url.should eq new_user_session_url
    end
  end

  context 'when logged in user' do

    background do
      sign_in_user user
    end

    scenario 'can create a new report successfully' do
      categories = create_list(:category, 3)
      visit new_report_path
      within '#new_report' do
        attach_file 'report[image]', File.join(Rails.root, '/spec/support/features/images/avatar.png')
        fill_in 'report[address]', with: '123 Governor Dr, San Diego, CA 92122'
        fill_in 'report[description]', with: 'No water'
        select categories.last.name, from: 'report[category_id]'
        click_button  'Guardar'
      end
      current_url.should eq root_url
      page.should have_content '123 Governor Dr, San Diego, CA 92122'
    end

  end

end
