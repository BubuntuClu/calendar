class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :new_notes

  private

  def new_notes
    @count = current_user.shared_notes.unseen.count if current_user
  end
end
