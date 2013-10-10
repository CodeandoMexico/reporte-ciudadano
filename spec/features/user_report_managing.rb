require 'spec_helper'
require 'active_support/core_ext/string/filters'

feature 'Managing reports' do

  let(:user) { create(:user) }
  let(:report) { create(:report, reportable: user) }

  context 'when not logged in user' do
    scenario 'get redirected to sign in page after trying to go to create a new report' do
      visit new_report_path
      current_url.should eq new_user_session_url
    end

    scenario 'can see a list of reports' do
      reports = create_list(:report, 2)
      visit reports_path
      page.should have_content reports.first.description.truncate(30)
      page.should have_content reports.last.description.truncate(30)
    end

    scenario 'can search for reports by min creation date' do
      reports = []
      reports << create(:report, created_at: 10.days.ago)
      reports << create(:report, created_at: 5.days.ago)
      reports << create(:report, created_at: 3.days.ago)
      visit reports_path
      within '#report_search' do
        fill_in 'q[date_gteq]', with: 3.days.ago.strftime("%Y-%m-%d").to_s
        click_button 'Buscar'
      end
      page.should have_content reports.last.description.truncate(30)
      page.should_not have_content reports.first.description.truncate(30)
      page.should_not have_content reports[1].description.truncate(30)
    end

    scenario 'can search for reports by max creation date' do
      reports = []
      reports << create(:report, created_at: 10.days.ago)
      reports << create(:report, created_at: 5.days.ago)
      reports << create(:report, created_at: 3.days.ago)
      visit reports_path
      within '#report_search' do
        fill_in 'q[date_lteq]', with: 4.days.ago.strftime("%Y-%m-%d").to_s
        click_button 'Buscar'
      end
      page.should_not have_content reports.last.description.truncate(30)
      page.should have_content reports.first.description.truncate(30)
      page.should have_content reports[1].description.truncate(30)
    end

    scenario 'can search for reports by category' do
      reports = create_list(:report, 3)
      visit reports_path
      within '#report_search' do
        select reports.first.category.name, from: 'q[category_id_eq]'
        click_button 'Buscar'
      end
      page.should have_content reports.first.description.truncate(30)
      page.should_not have_content reports[1].description.truncate(30)
      page.should_not have_content reports.last.description.truncate(30)
    end

    scenario 'can search for reports by status' do
      reports = create_list(:report, 3)
      visit reports_path
      within '#report_search' do
        select reports.first.status.name, from: 'q[status_id_eq]'
        click_button 'Buscar'
      end
      page.should have_content reports.first.description.truncate(30)
      page.should_not have_content reports[1].description.truncate(30)
      page.should_not have_content reports.last.description.truncate(30)
    end

    scenario 'can go see a report' do
      visit report_path(report)
      page.should have_content(report.category.name)
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

    scenario 'can vote on an report', js: true do
      visit report_path(report)
      page.find("a[href='/reports/#{report.id}/vote']").click
      page.should have_content('Votaste')
    end

    scenario 'can comment on a report'  do
      comment_content = 'This is my comment'
      visit report_path(report)
      within '#new_comment' do
        attach_file 'comment[image]', File.join(Rails.root, '/spec/support/features/images/avatar.png')
        fill_in 'comment[content]', with: comment_content
        click_button  'Comentar'
      end
      current_url.should eq report_url(report)
      page.should have_content(comment_content)
      page.should have_xpath("//img[@src=\"/uploads/comment/image/1/comment_avatar.png\"]")
    end

  end

end
