require_relative 'acceptance_helper'

feature 'Create note', %q{
  In order to create a reminder
  As an authenticated user
  I want to be able to create a note on a date
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:user3) { create(:user) }
  given(:note) { create(:note, user: user) }

  before do
    sign_in(user)
    visit note_path(note)
  end
  context 'Share note: note creator sight' do

    scenario 'Authenticated user share his note with another user', js: true do
      fill_in 'sharing_email', with: user2.email
      find('.js__share_note').click
      expect(page).to have_content 'Событие успешно расшарено.'
    end

    scenario 'Authenticated user share his note with another user twice', js: true do
      fill_in 'sharing_email', with: user2.email
      find('.js__share_note').click
      find('.js__share_note').click
      expect(page).to have_content 'Событие не было расшарено.'
    end

    scenario 'Authenticated user share his note with not existing user', js: true do
      find('.js__share_note').click
      expect(page).to have_content 'Нет такого пользователя.'
      fill_in 'sharing_email', with: 'not@existing.user'
      find('.js__share_note').click
      expect(page).to have_content 'Нет такого пользователя.'
    end

    scenario 'Authenticated user share his note with him self', js: true do
      fill_in 'sharing_email', with: user.email
      find('.js__share_note').click
      expect(page).to have_content 'Нет такого пользователя.'
    end
  end

  context 'Share note: another user sight' do

    scenario "Another authenticateduser can only see a shared note", js: true do
      fill_in 'sharing_email', with: user3.email
      find('.js__share_note').click
      expect(page).to have_content 'Событие успешно расшарено.'
      click_on 'Выйти'

      sign_in(user3)
      expect(page).to have_content 'У вас есть новые события(1)'
      click_on 'У вас есть новые события(1)'
      within '.panel-success' do
        expect(page).to have_content note.title
        expect(page).to have_content note.description.first(80) + '...'
        expect(page).to have_content user.email
      end
      click_on note.title
      expect(page).to_not have_content 'Редактировать'
      expect(page).to_not have_content 'Удалить'
      expect(page).to_not have_content 'Поделиться'

      visit root_path
      expect(page).to_not have_content 'У вас есть новые события(1)'
      expect(page).to have_content 'У вас есть новые события(0)'
    end
  end
end
