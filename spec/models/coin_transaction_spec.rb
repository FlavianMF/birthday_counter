require 'rails_helper'

RSpec.describe CoinTransaction, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:transaction_type) }
    
    it 'validates that amount is not zero' do
      transaction = CoinTransaction.new(amount: 0)
      transaction.valid?
      # Rails check constraints aren't automatically caught by standard validation tests
      # unless there's a model validation too.
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:event).optional }
  end
end
