require 'spec_helper'

feature 'As an admin I can manage requests services' do

  let(:admin) { create(:admin) }

  background do
    sign_in_admin admin
  end

  scenario 'I can see a list of services' do
    service = create(:service, name: 'service')
    visit admins_services_path
    expect(page).to have_content service.name
  end

  scenario 'I can create a new service' do
    visit admins_services_path
    click_link 'Nuevo servicio'
    fill_in 'service[name]', with: 'Servicio nuevo'
    click_button 'Guardar'
    expect(page).to have_content t('flash.service.created')
  end

  scenario 'I can edit a service' do
    service = create(:service)
    visit edit_admins_service_path(service)
    fill_in 'service[name]', with: 'Servicio editado'
    click_button 'Guardar'
    expect(page).to have_content t('flash.service.updated')
  end

  scenario 'I can delete a service' do
    service = create(:service, name: 'service')
    visit admins_services_path
    click_link 'destroy-btn'
    expect(page).not_to have_content service.name
    expect(page).to have_content t('flash.service.destroyed')
  end

  scenario 'I can create a new service with status message', js: true do
    create(:status, name: 'Abierto')

    visit admins_services_path
    click_link 'Nuevo servicio'
    fill_in 'service[name]', with: 'Servicio nuevo'

    click_link 'Agregar mensaje'
    within first('.add-message .fields') do
      fill_in 'Mensaje', with: 'Mensaje para status abierto'
      select 'Abierto', from: 'Estatus'
    end

    click_button 'Guardar'

    expect(page).to have_content t('flash.service.created')
  end

end
