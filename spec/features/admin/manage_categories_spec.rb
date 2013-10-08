require 'spec_helper'

feature 'As an admin I can manage report categories' do

  let(:admin) { create(:admin) }


  context 'Categories without statuses' do

    before :each do
      sign_in_admin admin
    end

    scenario 'I can see a list of categories' do
      category = create(:category, name: 'category')
      visit admins_categories_path
      page.should have_content category.name
    end

    scenario 'I can create a new category' do
      click_link 'Nueva categoría'
      fill_in 'category[name]', with: 'Categoría nueva'
      click_button 'Crear categoría'
      page.should have_content t('flash.category.created')
    end

    scenario 'I can edit a category' do
      category = create(:category)
      visit edit_admins_category_path(category)
      fill_in 'category[name]', with: 'Categoría editada'
      click_button 'Actualizar categoría'
      page.should have_content t('flash.category.updated')
    end

    scenario 'I can show a category' do
      category = create(:category, name: 'category')
      visit admins_categories_path
      click_link 'Mostrar'
      current_path.should == admins_category_path(category)
      page.should have_content category.name
    end

    scenario 'I can delete a category' do
      category = create(:category, name: 'category')
      visit admins_categories_path
      click_link 'Eliminar'
      page.should_not have_content category.name
      page.should have_content t('flash.category.destroyed')
    end
  end


  context 'Categories with statuses' do

    scenario 'I can create a new category with status message', js: true do
      admin = FactoryGirl.create(:admin)
      sign_in_admin admin

      status_open = create(:status, name: 'Abierto')
      status_revision = create(:status, name: 'Revision')

      click_link 'Nueva categoría'
      fill_in 'category[name]', with: 'Categoría nueva'

      click 'Agregar mensaje'
      fill_in 'category[nessages_attributes][0][content]', with: 'Mensaje para status abierto'
      select 'Abierto', from: 'category[messages_attributes][0][status_id'

      click 'Agregar mensaje'
      fill_in 'category[nessages_attributes][1][content]', with: 'Mensaje para status revision'
      select 'Revision', from: 'category[messages_attributes][1][status_id'

      click_button 'Crear categoría'

      page.should have_content t('flash.category.created')
      page.should have_content 'Categoria nueva'
      page.should have_content 'Mensaje para status abierto'
      page.should have_content 'Mensaje para status revision'
    end
  end

end
