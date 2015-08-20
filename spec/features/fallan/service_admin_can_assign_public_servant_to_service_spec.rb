require 'spec_helper'

feature 'As a service admin I can assign a public servant to a service', js:true do

  let(:admin) { create(:admin, :service_admin) }

  background do
    sign_in_admin admin
  end

  scenario 'I can assign a public servant' do
    public_servant = create :admin, :public_servant
    unassigned_service = create :service, name: "Fuga", service_admin_id: admin.id
    other_unassigned_service = create :service, name: "Tubería rota", service_admin_id: admin.id

    visit admins_dashboards_path
    click_link "Servidores públicos"
    click_link "Asignar trámites"

    expect(page).to have_content unassigned_service.name
    expect(page).to have_content other_unassigned_service.name

    select_from_chosen_by_css unassigned_service.name, from: "#admin_services_ids_chosen"
    click_button "Asignar"

    expect(page).to have_content "Fuga"
    expect(current_path).to eq admins_public_servants_path

    click_link "Asignar trámites"

    expect(selection_in_select_for(unassigned_service)).to be_selected
    expect(selection_in_select_for(other_unassigned_service)).not_to be_selected
  end

  scenario 'I can remove service assignation for a public servant' do
    public_servant = create :admin, :public_servant
    assigned_service = create :service, name: "Fuga", service_admin_id: admin.id, admins: [public_servant]

    visit admins_dashboards_path
    click_link "Servidores públicos"
    click_link "Asignar trámites"

    # uncheck "admin_services_ids_#{assigned_service.id}"
    click_button "Asignar"

    within first(".public_servant") do
      expect(page).not_to have_content "Fuga"
      expect(current_path).to eq admins_public_servants_path
    end

    click_link "Asignar trámites"
    expect(selection_in_select_for(assigned_service)).not_to be_selected
  end

  def checkbox(service)
    find("#admin_services_ids_#{service.id}")
  end
  def selection_in_select_for(service)
    find("#service_survey_service_ids").find(:xpath, "option[@value=#{service.id}]")
  end
end