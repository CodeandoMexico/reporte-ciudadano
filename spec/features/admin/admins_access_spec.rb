require 'spec_helper'

feature 'Admins access' do

  let(:super_admin) { create(:admin) }
  let(:service_admin) { create(:admin, :service_admin) }
  let(:public_servant) { create(:admin, :public_servant) }

  background do
  end

  scenario 'Super admin access' do
    sign_in_admin super_admin
    save_and_open_page

    within ".sidebar-nav" do
      expect(page).to have_link "Resumen"
      expect(page).to have_link "Reportes"
      expect(page).to have_link "Servicios"
      expect(page).to have_link "Administradores de servicios"
      expect(page).to have_link "Diseño"
      expect(page).to have_link "API"
    end
  end
end