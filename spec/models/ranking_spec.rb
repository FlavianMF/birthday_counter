require 'rails_helper'

RSpec.describe Ranking, type: :model do
  describe 'score calculations' do
    let(:user) { create(:user) }
    let(:event) { create(:event) }
    let(:ranking) { create(:ranking, user: user, event: event, streak_days: 0, total_score: 0) }

    it 'adds score with 1x multiplier for 0 streak' do
      ranking.add_score(100)
      expect(ranking.total_score).to eq(100)
    end

    it 'adds score with 1.5x multiplier for 3 day streak' do
      ranking.update(streak_days: 3, last_activity_date: Time.current)
      ranking.add_score(100)
      expect(ranking.total_score).to eq(150)
    end

    it 'adds score with 2x multiplier for 7 day streak' do
      ranking.update(streak_days: 7, last_activity_date: Time.current)
      ranking.add_score(100)
      expect(ranking.total_score).to eq(200)
    end
  end

  describe 'coin management' do
    let(:ranking) { create(:ranking, coins: 1000) }

    it 'allows spending coins if balance is sufficient' do
      expect(ranking.spend_coins(500)).to be true
      expect(ranking.coins).to eq(500)
    end

    it 'prevents spending if balance is insufficient' do
      expect(ranking.spend_coins(1500)).to be false
      expect(ranking.coins).to eq(1000)
    end
  end
end
