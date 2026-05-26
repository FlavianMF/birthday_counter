require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:target_date) }
    it { should validate_inclusion_of(:status).in_array(%w[active climax post_event archived]) }

    it 'validates that target_date is in the future on create' do
      event = Event.new(name: 'Past Event', target_date: 1.day.ago)
      expect(event).not_to be_valid
      expect(event.errors[:target_date]).to include('deve ser uma data futura')
    end
  end

  describe 'associations' do
    it { should belong_to(:host).class_name('User').optional }
    it { should belong_to(:sponsor).class_name('User').optional }
    it { should have_many(:messages).dependent(:destroy) }
    it { should have_many(:rankings).dependent(:destroy) }
  end

  describe 'invitation logic' do
    let(:sponsor) { create(:user, role: 'sponsor') }

    it 'generates an invitation token for surprise events without a host' do
      event = Event.create!(
        name: "Surprise", 
        target_date: 1.day.from_now, 
        is_surprise: true, 
        sponsor: sponsor,
        host: nil
      )
      expect(event.invitation_token).not_to be_nil
    end

    it 'does not generate a token if host is already present' do
      host = create(:user, role: 'host')
      event = Event.create!(
        name: "Not Surprise", 
        target_date: 1.day.from_now, 
        is_surprise: true, 
        host: host
      )
      expect(event.invitation_token).to be_nil
    end

    describe '#claim_by!' do
      let(:event) { create(:event, :surprise, host: nil, invitation_token: 'test_token') }
      let(:new_host) { create(:user) }

      it 'associates the user as host and clears the token' do
        event.claim_by!(new_host)
        
        expect(event.host).to eq(new_host)
        expect(event.invitation_token).to be_nil
        expect(event.invitation_claimed_at).not_to be_nil
      end

      it 'adds the user as a participant with host role' do
        event.claim_by!(new_host)
        
        participant = event.event_participants.find_by(user: new_host)
        expect(participant).not_to be_nil
        expect(participant.role).to eq('host')
      end
    end
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
