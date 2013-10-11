require 'spec_helper'

feature 'As an admin I can manage reports' do

  let(:admin) {create(:admin)}
  let(:report) {create(:report)}

  background do
    sign_in_admin admin
  end

  scenario 'I can update the status of a report' do
    statuses = create_list(:status, 3)
    visit report_path(report)
    within '.edit_report' do
      select statuses.first.name, from: 'report[status_id]'
    end
    click_button 'Actualizar'
    page.should have_content "Status: #{statuses.first.name}"
  end

  scenario 'I can update a full report' do
    categories = create_list(:category, 2)
    visit edit_admins_report_path(report)
    within '.edit_report' do
      select categories.last.name, from: 'report[category_id]'
    end
    click_button 'Guardar'
    page.should have_content categories.last.name
    current_url.should eq report_url(report)
  end

  scenario 'I can delete a report' do
    route = "/admins/reports/#{report.id}"
    visit reports_path
    page.find("a[href='#{route}']").click
    page.should have_content 'El reporte fue eliminado correctamente'
  end

end
