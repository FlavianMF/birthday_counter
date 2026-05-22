require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:target_date) }
    it { should validate_inclusion_of(:status).in_array(%w[active climax post_event archived]) }
  end

  describe 'associations' do
    it { should belong_to(:host).class_name('User') }
    it { should have_many(:messages).dependent(:destroy) }
    it { should have_many(:rankings).dependent(:destroy) }
  end

  describe 'state transitions' do
    let(:event) { create(:event, status: 'active', target_date: 1.hour.from_now) }

    it 'transitions to climax' do
      create(:message, event: event, is_revealed: false)
      event.transition_to_climax!
      expect(event.status).to eq('climax')
      expect(event.messages.first.is_revealed).to be true
    end

    it 'identifies if it should be climax' do
      event.update_columns(target_date: 1.hour.ago, created_at: 2.hours.ago)
      expect(event.should_be_climax?).to be true
    end
  end
end
