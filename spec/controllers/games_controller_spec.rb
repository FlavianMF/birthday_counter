require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:user) { create(:user) }
  let(:event) { create(:event, host: user) }
  let!(:ranking) { create(:ranking, user: user, event: event, total_score: 100, coins: 10) }

  before do
    session[:user_id] = user.id
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "POST #play" do
    context "when answer is correct" do
      it "adds score and coins to the ranking" do
        post :play, params: { event_id: event.id, is_correct: true }, format: :json
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        
        ranking.reload
        expect(ranking.total_score).to eq(600) # 100 + 500
        expect(ranking.coins).to eq(60)       # 10 + 50
        expect(json_response['score']).to eq(500)
        expect(json_response['coins_earned']).to eq(50)
      end

      it "applies streak multiplier correctly" do
        ranking.update!(streak_days: 7, last_activity_date: 1.day.ago)
        
        post :play, params: { event_id: event.id, is_correct: true }, format: :json
        
        json_response = JSON.parse(response.body)
        expect(json_response['score']).to eq(1000) # 500 * 2.0
        expect(json_response['coins_earned']).to eq(100) # 1000 / 10
        
        ranking.reload
        expect(ranking.total_score).to eq(1100) # 100 + 1000
        expect(ranking.coins).to eq(110) # 10 + 100
      end

      it "creates a CoinTransaction" do
        expect {
          post :play, params: { event_id: event.id, is_correct: true }, format: :json
        }.to change(CoinTransaction, :count).by(1)
        
        transaction = CoinTransaction.last
        expect(transaction.amount).to eq(50)
        expect(transaction.transaction_type).to eq('earned')
      end
    end

    context "when answer is incorrect" do
      it "does not add score or coins but maintains/updates streak" do
        ranking.update!(streak_days: 2, last_activity_date: 1.day.ago)
        
        expect {
          post :play, params: { event_id: event.id, is_correct: false }, format: :json
        }.not_to change { ranking.reload.total_score }
        
        ranking.reload
        expect(ranking.streak_days).to eq(3)
        expect(ranking.last_activity_date.to_date).to eq(Date.current)
      end
    end
  end
end
