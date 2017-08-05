require_relative 'acceptance_helper'

feature 'User sign in', %q{
  In order to be able to create note
  As an User
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'invalid@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Authenticated user try to sign out' do
    sign_in(user)
    click_on 'Выйти'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'User try to sign up' do
    visit new_user_session_path
    click_on 'Sign up'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

end
