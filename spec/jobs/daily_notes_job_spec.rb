require 'rails_helper'

RSpec.describe DailyNotesJob, type: :job do
  let(:users) { create_list(:user, 2) }
  let(:note) { create(:note, user: users[0]) }
  let(:note2) { create(:note, user: users[1]) }

  it 'sends daily digest to users' do
    users.each do |user|
      expect(DailyMailer).to receive(:digest).with(user).and_call_original
    end
    DailyNotesJob.perform_now
  end
end
