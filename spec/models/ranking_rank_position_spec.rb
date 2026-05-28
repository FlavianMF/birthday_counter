require 'rails_helper'

RSpec.describe Ranking, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:event1) { create(:event, host: user1) }
  let(:event2) { create(:event, host: user1) }

  describe "#rank_position" do
    context "global rank" do
      it "calculates the correct global position based on total score across all events" do
        # User 1: Event 1 (100) + Event 2 (200) = 300
        create(:ranking, user: user1, event: event1, total_score: 100)
        create(:ranking, user: user1, event: event2, total_score: 200)

        # User 2: Event 1 (500) = 500
        ranking2 = create(:ranking, user: user2, event: event1, total_score: 500)

        # Check ranking for User 1 in any event
        ranking1 = Ranking.find_by(user: user1, event: event1)
        expect(ranking1.rank_position).to eq(2)

        expect(ranking2.rank_position).to eq(1)
      end
    end

    context "event rank" do
      it "calculates the correct position within a specific event" do
        r1 = create(:ranking, user: user1, event: event1, total_score: 100)
        r2 = create(:ranking, user: user2, event: event1, total_score: 500)

        expect(r1.rank_position).to eq(2)
        expect(r2.rank_position).to eq(1)
      end
    end
  end
end
