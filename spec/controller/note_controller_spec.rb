require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  before do 
    @user = create(:user)
    @user2 = create(:user)
    @shared_user = create(:user)
    @note = create(:note, user: @user)
    @shared_note = create(:shared_note, user_id: @shared_user.id, note_id: @note.id)
  end
  

  describe 'POST #share_note' do
    sign_in_user

    context 'valid sharing' do
      it 'increase shared_notes count' do
        expect { post :share_note, params: { user_email: @user2.email, id: @note.id, format: :json } }.to change(@user2.shared_notes, :count).by(1)
      end

      it 'render json success answer' do
        post :share_note, params: { user_email: @user2.email, id: @note.id, format: :json }
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq("{\"msg\":\"Событие успешно расшарено.\"}")
      end
    end

    context 'invalid sharing' do
      it 'not increase shared_notes count' do
        expect { post :share_note, params: { user_email: @user.email, id: @note.id, format: :json } }.to change(@user.shared_notes, :count).by(0)
      end

      it 'render json success answer' do
        post :share_note, params: { user_email: @user.email, id: @note.id, format: :json }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq("{\"msg\":\"Нет такого пользователя.\"}")
      end

      it 'not increase twice shared_notes count, when try to share twice' do
        expect { post :share_note, params: { user_email: @user2.email, id: @note.id, format: :json } }.to change(@user2.shared_notes, :count).by(1)
        expect { post :share_note, params: { user_email: @user2.email, id: @note.id, format: :json } }.to change(@user2.shared_notes, :count).by(0)
      end

      it 'render json success answer' do
        post :share_note, params: { user_email: @user2.email, id: @note.id, format: :json }
        post :share_note, params: { user_email: @user2.email, id: @note.id, format: :json }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq("{\"msg\":\"Событие не было расшарено.\"}")
      end
    end
  end

  describe 'GET #show' do
    before do
      sign_in @shared_user
      get :show, id: @note.id 
    end

    it 'set shared not as seen' do
      @shared_note.reload
      expect(@shared_note.seen).to be true
    end
  end
end
