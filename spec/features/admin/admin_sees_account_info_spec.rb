require 'spec_helper'

feature 'Admin sees account info' do

  let(:service_admin) { create(:admin, :service_admin, dependency: "La dependencia", administrative_unit: "La unidad") }
  let(:public_servant) { create(:admin, :public_servant, dependency: "La dependencia", administrative_unit: "La unidad") }

  scenario 'but can not edit them being service admin' do
    sign_in_admin service_admin

    visit edit_admins_registration_path(service_admin)
    expect(dependency_field.value).to eq 'La dependencia'
    expect(administrative_unit_field.value).to have_content 'La unidad'
  end

  scenario 'but can not edit them being public servant' do
    sign_in_admin public_servant

    visit edit_admins_registration_path(public_servant)
    expect(dependency_field.value).to eq 'La dependencia'
    expect(administrative_unit_field.value).to have_content 'La unidad'
  end

  def dependency_field
    find_field("admin[dependency]", disabled: true)
  end

  def administrative_unit_field
    find_field("admin[administrative_unit]", disabled: true)
  end
end
