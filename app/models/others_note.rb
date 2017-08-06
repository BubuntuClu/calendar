class OthersNote < ApplicationRecord
  self.table_name = 'notes'
  
  belongs_to :user

  scope :today, -> { where(calendar_date: Time.zone.now) }
end
