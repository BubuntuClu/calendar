class Note < ApplicationRecord
  belongs_to :user

  validates :title, :description, :calendar_date, presence: { message: 'не может быть пустым' }

  scope :today, -> { where(calendar_date: Time.zone.now) }
end
