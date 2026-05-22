require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:event_id) }
    it { should validate_inclusion_of(:message_type).in_array(%w[text image video audio]) }
  end

  describe 'associations' do
    it { should belong_to(:event) }
    it { should belong_to(:sender).class_name('User').optional }
  end

  describe 'defaults' do
    it 'sets is_revealed to false by default' do
      message = Message.new
      expect(message.is_revealed).to be false
    end
  end
end
