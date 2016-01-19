require 'spec_helper'

feature 'Signing in' do

  scenario 'through facebook button' do
    OmniAuth.config.mock_auth[:facebook] = omniauth_facebook_valid_hash
    visit new_user_registration_path
    click_link 'Facebook'
    expect(page).to have_content 'Joe Bloggs'
    expect(current_url).to eq root_url
  end

  scenario 'through twitter button' do
    OmniAuth.config.mock_auth[:twitter] = omniauth_twitter_valid_hash
    visit new_user_registration_path
    click_link 'Twitter'
    fill_in 'user[email]', with: 'johnq@mail.com'
    click_button "Completar"
    expect(page).to have_content 'John Q Public'
    expect(current_url).to eq root_url
  end

  scenario 'through registration form' do
    visit new_user_registration_path
    within '#new_user' do
      fill_in 'user[email]', with: 'eddie@myemail.com'
      fill_in 'user[password]', with: 'superinsecurepassword'
      fill_in 'user[password_confirmation]', with: 'superinsecurepassword'
      fill_in 'user[telephone_number]', with: "2222222222"
    end
    click_button "Regístrate"
    expect(page).to have_content 'eddie@myemail.com'
    expect(current_url).to eq root_url
  end

  scenario 'with invalid credentials redirects' do
    OmniAuth.config.mock_auth[:facebook] = :invalid
    visit new_user_registration_path
    click_link 'Facebook'
    expect(page).to have_content t('devise.omniauth_callbacks.failure', kind: 'Facebook', reason: 'Invalid')
    expect(current_url).to eq new_user_session_url
  end
end

feature 'As a user I can login' do

  let(:user) {create(:user, password: 'superinsecurepassword', password_confirmation: 'superinsecurepassword')}

  scenario 'through facebook button' do
    OmniAuth.config.mock_auth[:facebook] = omniauth_facebook_valid_hash
    visit new_user_session_path
    click_link 'Facebook'
    expect(page).to have_content 'Joe Bloggs'
    expect(current_url).to eq root_url
  end

  scenario 'through twitter button' do
    OmniAuth.config.mock_auth[:twitter] = omniauth_twitter_valid_hash
    visit new_user_session_path
    click_link 'Twitter'
    fill_in 'user[email]', with: 'johnq@mail.com'
    click_button "Completar"
    expect(page).to have_content 'John Q Public'
    expect(current_url).to eq root_url
  end

  scenario 'through registration form' do
    visit new_user_session_path
    within '#new_user' do
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: 'superinsecurepassword'
    end
    click_button 'Entrar'
    expect(page).to have_content user.name
    expect(current_url).to eq root_url
  end
end
