require 'spec_helper'

feature 'Admins access' do

  let(:super_admin) { create(:admin) }
  let(:service_admin) { create(:admin, :service_admin) }
  let(:public_servant) { create(:admin, :public_servant) }

  scenario 'Super admin access' do
    sign_in_admin super_admin

    expect(page).to have_content "Panel de administración"
    within ".sidebar-nav" do
      expect(page).to have_link "Resumen"
      expect(page).to have_link "Quejas o sugerencias"
      expect(page).to have_link "Servicios"
      expect(page).to have_link "Administradores de servicios"
      expect(page).to have_link "Diseño"
      expect(page).to have_link "API"
      expect(page).to have_link "Personalizar quejas o sugerencias"
      expect(page).to have_link "Servidores Públicos"
    end
  end

  scenario 'Service admin access' do
    sign_in_admin service_admin

    expect(page).to have_content "Panel de administración"
    within ".sidebar-nav" do
      expect(page).not_to have_link "Resumen"
      expect(page).not_to have_link "Administradores de servicios"
      expect(page).not_to have_link "Diseño"
      expect(page).not_to have_link "API"
      expect(page).not_to have_link "Personalizar quejas o sugerencias"

      expect(page).to have_link "Quejas o sugerencias"
      expect(page).to have_link "Servicios"
      expect(page).to have_link "Servidores Públicos"
    end
  end

  scenario 'Public servant access' do
    sign_in_admin public_servant
    expect(current_path).to eq admins_service_requests_path

    expect(page).to have_content "Panel de administración"
    within ".sidebar-nav" do
      expect(page).not_to have_link "Resumen"
      expect(page).not_to have_link "Administradores de servicios"
      expect(page).not_to have_link "Diseño"
      expect(page).not_to have_link "API"
      expect(page).not_to have_link "Personalizar quejas o sugerencias"
      expect(page).not_to have_link "Servicios"
      expect(page).not_to have_link "Servidores Públicos"

      expect(page).to have_link "Quejas o sugerencias"
    end
  end
end