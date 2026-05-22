require 'rails_helper'

RSpec.describe ActiveEffect, type: :model do
  describe 'associations' do
    it { should belong_to(:event) }
    it { should belong_to(:user) }
    it { should belong_to(:shop_item) }
  end

  describe 'scopes' do
    it 'returns active effects' do
      active = create(:active_effect, active: true)
      inactive = create(:active_effect, active: false)
      expect(ActiveEffect.where(active: true)).to include(active)
      expect(ActiveEffect.where(active: true)).not_to include(inactive)
    end
  end
end
