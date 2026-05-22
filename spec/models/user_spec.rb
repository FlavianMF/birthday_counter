require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_inclusion_of(:role).in_array(%w[host guest sponsor admin]) }
  end

  describe 'associations' do
    it { should have_many(:hosted_events).class_name('Event').with_foreign_key(:host_id) }
    it { should have_many(:messages).with_foreign_key(:sender_id) }
    it { should have_many(:rankings) }
    it { should have_many(:coin_transactions) }
  end
end
