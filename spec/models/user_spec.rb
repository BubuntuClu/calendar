require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:notes).dependent(:destroy) }
    it { should have_many(:shared_notes) }
    it { should have_many(:others_notes) }
  end
end
