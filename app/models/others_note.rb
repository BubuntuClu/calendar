class OthersNote < ApplicationRecord
  self.table_name = 'notes'
  
  belongs_to :user
end
