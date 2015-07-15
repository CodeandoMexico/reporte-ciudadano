require 'spec_helper'

feature 'As a service admin I can create new public servant' do

  let(:admin) { create(:admin, :service_admin, dependency: "Dependencia 1") }
  let(:super_admin) { create(:admin) }

  scenario 'I can see a list of public servants in my dependency' do
    sign_in_admin admin

    public_servants = create_list(:admin, 3, :public_servant, dependency: admin.dependency)
    other_public_servant = create :admin, :public_servant

    visit admins_dashboards_path
    click_link "Servidores públicos"

    expect(page).to have_content public_servants.first.name
    expect(page).not_to have_content other_public_servant.name
    expect(public_servants_count).to eq 3
  end

  scenario 'I can see a list of public servants in my dependency if I am a super admin' do
    sign_in_admin super_admin

    public_servants = create_list(:admin, 3, :public_servant, dependency: admin.dependency)
    other_public_servant = create :admin, :public_servant

    visit admins_dashboards_path
    click_link "Servidores públicos"

    expect(page).to have_content public_servants.first.name
    expect(page).to have_content other_public_servant.name
    expect(public_servants_count).to eq 4
  end

  scenario 'I can create a new public servant with valid data' do
    sign_in_admin admin

    services = create_list(:service, 2)
    last_service = services.last

    visit admins_public_servants_path
    click_link "Agregar servidor público"

    fill_in "admin[name]", with: "María Gómez"
    fill_in "admin[email]", with: "maria@mail.com"
    fill_in "admin[record_number]", with: "Ma01"
    expect(page).not_to have_content "Dependencia 2"
    select "Dependencia 1", from: "admin[dependency]"
    select administrative_unit, from: "admin[administrative_unit]"
    fill_in "admin[charge]", with: "Servidor"

    click_button "Guardar"

    expect(page).to have_content "El servidor público se ha registrado exitosamente."
    expect(current_path).to eq admins_public_servants_path
    expect(page).to have_content "María Gómez"
    expect_mail_sent_to "maria@mail.com"
  end

  def expect_mail_sent_to(email)
    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.to).to include(email)
    expect(last_email.subject).to include "Bienvenido a"
  end

  def public_servants_count
    all(:css, ".public_servant").size
  end
end
