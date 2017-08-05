class Note < ApplicationRecord
  belongs_to :user

  validates :title, :description, :calendar_date, presence: { message: 'не может быть пустым' }
end
