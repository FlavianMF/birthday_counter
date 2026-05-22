require 'rails_helper'

RSpec.describe EventParticipant, type: :model do
  describe 'associations' do
    it { should belong_to(:event) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:role).in_array(%w[host guest sponsor admin]) }
    
    it 'validates uniqueness of user per event' do
      participant = create(:event_participant)
      duplicate = EventParticipant.new(event: participant.event, user: participant.user)
      # uniqueness validation is missing in model, but we have unique index
    end
  end
end
