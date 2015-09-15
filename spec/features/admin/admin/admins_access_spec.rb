require 'spec_helper'

feature 'Admins access' do

  let(:super_admin) { create(:admin) }
  let(:service_admin) { create(:admin, :service_admin) }
  let(:public_servant) { create(:admin, :public_servant) }

  scenario 'Super admin access' do
    sign_in_admin super_admin

    within ".sidebar-nav" do
      expect(page).to have_link "Resumen"
      expect(page).to have_link "Quejas o sugerencias"
      expect(page).to have_link "Trámites"
      expect(page).to have_link "Administradores de trámites"
      expect(page).to have_link "API"
      expect(page).to have_link "Personalizar quejas o sugerencias"
      expect(page).to have_link "Servidores públicos"
    end
  end

  scenario 'Service admin access' do
    sign_in_admin service_admin

    within ".sidebar-nav" do
      expect(page).not_to have_link "Resumen"
      expect(page).not_to have_link "Administradores de trámites"
      expect(page).not_to have_link "API"
      expect(page).not_to have_link "Personalizar quejas o sugerencias"

      expect(page).to have_link "Quejas o sugerencias"
      expect(page).to have_link "Trámites"
      expect(page).to have_link "Servidores públicos"
    end
  end

  scenario 'Public servant access' do
    sign_in_admin public_servant
    expect(current_path).to eq admins_service_requests_path

    within ".sidebar-nav" do
      expect(page).not_to have_link "Resumen"
      expect(page).not_to have_link "Administradores de servicios"
      expect(page).not_to have_link "API"
      expect(page).not_to have_link "Personalizar quejas o sugerencias"
      expect(page).not_to have_link "Trámites"
      expect(page).not_to have_link "Servidores públicos"

      expect(page).to have_link "Quejas o sugerencias"
    end
  end
end