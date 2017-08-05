require_relative 'acceptance_helper'

feature 'Create/Edit/Delete note', %q{
  In order to work with a note
  As an authenticated user
  I want to be able to create/edit/delete a note on a date
} do

  given(:user) { create(:user) }
  
  context 'Create note' do
    scenario 'Authenticated user creates note' do
      sign_in(user)
      click_on 'Создать новое событие'
      fill_in 'Title', with: 'Test note'
      fill_in 'Description', with: 'Text testx note'
      fill_in 'Calendar date', with: Time.now
      click_on 'Создать событие'
      expect(page).to have_content 'Test note'
      expect(page).to have_content 'Text testx note'
      expect(page).to have_content Time.now.strftime('%d.%m.%Y')

      visit root_path
      within '.panel-success' do
        expect(page).to have_content 'Test note'
        expect(page).to have_content 'Text testx note'.first(80) + '...'
      end
    end

    scenario 'Authenticated user creates invalid note' do
      sign_in(user)
      click_on 'Создать новое событие'
      click_on 'Создать событие'
      within '.error_msg.title' do
        expect(page).to have_content 'не может быть пустым'
      end
      within '.error_msg.description' do
        expect(page).to have_content 'не может быть пустым'
      end
      within '.error_msg.calendar_date' do
        expect(page).to have_content 'не может быть пустым'
      end
    end

    scenario 'Non-authenticated user try to creates note' do
      visit root_path
      expect(page).to_not have_content 'Создать новое событие'
    end
  end

  context 'edit note' do
    given(:note) { create(:note, user: user) }

    before do
      sign_in(user)
      visit note_path(note)
    end

    scenario 'Authenticated user edits his note successfully' do
      click_on 'Редактировать'
      fill_in 'Title', with: 'New text'
      fill_in 'Description', with: 'NEW Text testx note'
      fill_in 'Calendar date', with: '04.04.2017'
      click_on 'Обновить событие'
      expect(page).to have_content 'New text'
      expect(page).to have_content 'NEW Text testx note'
      expect(page).to have_content '04.04.2017'
    end

    scenario 'Authenticated user edits his note unsuccessfully' do
      click_on 'Редактировать'
      fill_in 'Title', with: ''
      fill_in 'Description', with: 'NEW Text testx note'
      fill_in 'Calendar date', with: '04.04.2017'
      click_on 'Обновить событие'
      within '.error_msg.title' do
        expect(page).to have_content 'не может быть пустым'
      end
    end
  end

  context 'delete note' do
    given(:note) { create(:note, user: user) }

    before do
      sign_in(user)
      visit note_path(note)
    end

    scenario 'Authenticated user deletes his note successfully' do
      click_on 'Удалить'
      expect(current_path).to eq notes_path
      expect(page).to_not have_selector '.panel-success'
    end

  end
end
