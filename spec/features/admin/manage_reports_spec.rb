require 'spec_helper'

feature 'As an admin I can manage reports' do

  let(:admin) {create(:admin)}
  let!(:report) {create(:report)}

  background do
    sign_in_admin admin
  end

  scenario 'I can see a the reports index list' do
    reports = create_list(:report, 3)
    within '.sidebar-nav' do
      click_link 'Reportes'
    end
    current_path == admins_reports_path
    page.should have_content reports.first.category.name
    page.should have_content reports[1].category.name
    page.should have_content reports.last.category.name
  end

  scenario 'I can go to admin view for a report' do
    visit admins_reports_path
    click_link report.category.name

    current_path == edit_admins_report_path(report)
    page.should have_content report.category.name
    page.should have_content report.status
  end

  scenario 'I can see the reporters full name and email' do
    visit admins_reports_path
    click_link report.category.name

    current_path == edit_admins_report_path(report)
    page.should have_content report.reportable.name
    page.should have_content report.reportable.email
    page.should have_content report.reportable.id
  end

  scenario 'I can update the status of a report' do
    statuses = create_list(:status, 3)
    visit edit_admins_report_path(report)
    within '.edit_report' do
      select statuses.first.name, from: 'report[status_id]'
    end
    click_button 'Actualizar'
    page.should have_content "Status: #{statuses.first.name}"
  end

  scenario 'I can update the category of a report' do
    categories = create_list(:category, 2)
    visit edit_admins_report_path(report)
    within '.edit_report' do
      select categories.last.name, from: 'report[category_id]'
    end
    click_button 'Actualizar'
    current_path.should == edit_admins_report_path(report)
    page.should have_content categories.last.name
  end

  scenario 'I can delete a report' do
    route = "/admins/reports/#{report.id}"
    visit reports_path
    page.find("a[href='#{route}']").click
    page.should have_content 'El reporte fue eliminado correctamente'
  end

end
