require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title).with_message(/не может быть пустым/) }
    it { should validate_presence_of(:description).with_message(/не может быть пустым/) }
    it { should validate_presence_of(:calendar_date).with_message(/не может быть пустым/) }
  end
end
