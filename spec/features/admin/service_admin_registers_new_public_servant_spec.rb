require 'spec_helper'

feature 'As a service admin I can create new public servant' do

  let(:admin) { create(:admin, :service_admin) }

  background do
    sign_in_admin admin
  end

  scenario 'I can see a list of public servants' do
    public_servants = create_list(:admin, 3, :public_servant)

    visit admins_dashboards_path
    click_link "Servidores Públicos"

    expect(page).to have_content public_servants.first.name
    expect(public_servants_count).to eq 3
  end

  scenario 'I can create a new public servant with valid data' do
    services = create_list(:service, 2)
    last_service = services.last

    visit admins_public_servants_path
    click_link "Agregar servidor público"

    fill_in "admin[name]", with: "María Gómez"
    fill_in "admin[email]", with: "maria@mail.com"
    fill_in "admin[record_number]", with: "Ma01"
    fill_in "admin[dependency]", with: "Dependencia"
    fill_in "admin[administrative_unit]", with: "Unidad"
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
