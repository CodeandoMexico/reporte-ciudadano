require 'spec_helper'

feature 'As an admin I can manage report categories' do

  let(:admin) { create(:admin) }

  background do
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

  scenario 'I can create a new category with status message', js: true do
    create(:status, name: 'Abierto')

    click_link 'Nueva categoría'
    fill_in 'category[name]', with: 'Categoría nueva'

    click_link 'Agregar mensaje'
    within '#new_category' do
      fill_in 'Mensaje', with: 'Mensaje para status abierto'
      select 'Abierto', from: '¿Que estatus?'
    end

    click_button 'Crear categoría'

    page.should have_content t('flash.category.created')
  end

end
