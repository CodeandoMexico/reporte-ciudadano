require 'spec_helper'

feature 'Signing in' do

  scenario 'through facebook button' do
    OmniAuth.config.mock_auth[:facebook] = omniauth_facebook_valid_hash
    visit new_user_registration_path
    click_link 'Facebook'
    page.should have_content 'Joe Bloggs'
    current_url.should == root_url
  end

  scenario 'through twitter button' do
    OmniAuth.config.mock_auth[:twitter] = omniauth_twitter_valid_hash
    visit new_user_registration_path
    click_link 'Twitter'
    page.should have_content 'John Q Public'
    current_url.should == root_url
  end

  scenario 'through registration form' do
    visit new_user_registration_path
    within '#new_user' do
      fill_in 'user[email]', with: 'eddie@myemail.com'
      fill_in 'user[password]', with: 'superinsecurepassword'
      fill_in 'user[password_confirmation]', with: 'superinsecurepassword'
    end
    click_button 'Registrarme'
    page.should have_content 'eddie@myemail.com'
    current_url.should == root_url
  end

  scenario 'with invalid credentials redirects' do
    OmniAuth.config.mock_auth[:facebook] = :invalid
    visit new_user_registration_path
    click_link 'Facebook'
    page.should have_content t('devise.omniauth_callbacks.failure', kind: 'Facebook', reason: 'Invalid')
    current_url.should == new_user_session_url
  end

end

feature 'As a user I can login' do

  let(:user) {create(:user, password: 'superinsecurepassword', password_confirmation: 'superinsecurepassword')}

  scenario 'through facebook button' do
    OmniAuth.config.mock_auth[:facebook] = omniauth_facebook_valid_hash
    visit new_user_session_path
    click_link 'Facebook'
    page.should have_content 'Joe Bloggs'
    current_url.should == root_url
  end

  scenario 'through twitter button' do
    OmniAuth.config.mock_auth[:twitter] = omniauth_twitter_valid_hash
    visit new_user_session_path
    click_link 'Twitter'
    page.should have_content 'John Q Public'
    current_url.should == root_url
  end

  scenario 'through registration form' do
    visit new_user_session_path
    within '#new_user' do
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: 'superinsecurepassword'
    end
    click_button 'Entrar'
    page.should have_content user.name
    current_url.should eq root_url
  end

end
