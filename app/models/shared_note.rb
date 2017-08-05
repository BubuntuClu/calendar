class SharedNote < ApplicationRecord
  belongs_to :user
  belongs_to :note

  scope :unseen, -> { where(seen: false) }
end
