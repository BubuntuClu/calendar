class NotesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_note, only: [:show, :edit, :destroy, :update]

  respond_to :html, :js
  def index
    if current_user
      time = params[:date]
      time ||= Time.now
      @notes = Note.where(user_id: current_user.id, calendar_date: time)
      @others_notes = current_user.others_notes.where(calendar_date: time)
    end
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.create(note_params.merge(user_id: current_user.id))
    respond_with @note
  end

  def show
    shared = SharedNote.where(user_id: current_user, note_id: @note.id, seen: false).first
    shared.update_attribute(:seen, true) if shared
    redirect_to root_path if !current_user.others_notes.include?(@note) && @note.user != current_user
  end

  def edit
  end

  def update
    @note.update(note_params)
    respond_with @note
  end

  def destroy
    @note.destroy if @note.user == current_user
    redirect_to notes_path
  end

  def share_note
    user_id = User.where(email: params[:user_email]).pluck(:id).first
    error = nil
    if user_id && user_id != current_user.id
      shared_note = SharedNote.new(user_id: user_id, note_id: params[:id])
      begin
        if shared_note.save
          render json: { msg: 'Событие успешно расшарено.' }
        end
      rescue
        error = 'Событие не было расшарено.'
      end
    else
      error = 'Нет такого пользователя.'
    end
    if error.present?
      render(
        json: { msg: error },
        status: :unprocessable_entity
      )
    end
  end

  def shared_notes
    @others_notes = current_user.others_notes.where('shared_notes.seen = false')
  end

  private

  def find_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :description, :calendar_date)
  end
end
