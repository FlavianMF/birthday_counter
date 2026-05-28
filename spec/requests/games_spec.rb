require 'rails_helper'

RSpec.describe "Games", type: :request do
  let(:user) { create(:user) }
  let(:event) { create(:event, host: user) }

  describe "GET /events/:event_id/games/fact_or_fiction" do
    it "renders the fact or fiction game page" do
      # Login via session for web request
      post login_path, params: { email: user.email, password: 'password123' }
      
      get fact_or_fiction_event_games_path(event)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Fact or Fiction")
    end
  end

  describe "POST /api/v1/events/:event_id/games/fact-or-fiction/play" do
    let(:api_path) { "/api/v1/events/#{event.id}/games/fact-or-fiction/play" }

    it "persists score and coins when the answer is correct" do
      # Ensure no ranking exists before
      Ranking.delete_all

      expect {
        post api_path, 
             params: { is_correct: true }, 
             headers: auth_headers(user),
             as: :json
      }.to change(Ranking, :count).by(1)

      ranking = Ranking.last
      expect(ranking.total_score).to eq(500)
      expect(ranking.coins).to eq(50)
      expect(response).to have_http_status(:ok)
    end

    it "does not add score when the answer is incorrect but maintains ranking" do
      # Ensure ranking exists
      ranking = Ranking.find_or_create_by!(event: event, user: user)
      
      post api_path, 
           params: { is_correct: false }, 
           headers: auth_headers(user),
           as: :json
      
      expect(ranking.reload.total_score).to eq(0)
      expect(response).to have_http_status(:ok)
    end
  end
end
