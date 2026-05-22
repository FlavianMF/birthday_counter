require 'rails_helper'

RSpec.describe "API::V1::Games", type: :request do
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  # Mock JWT token
  let(:token) { JwtEncoder.encode({ user_id: user.id }) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  describe "POST /api/v1/events/:event_id/games/geoguessr/play" do
    let(:params) do
      {
        guess: { lat: -23.5505, lng: -46.6333 }, # São Paulo
        actual_lat: -23.5505,
        actual_lng: -46.6333
      }
    end

    it "returns maximum score for exact match" do
      post "/api/v1/events/#{event.id}/games/geoguessr/play", params: params, headers: headers
      
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["score"]).to eq(5000)
      expect(json["coins_earned"]).to eq(500)
    end

    it "calculates decaying score for distant match" do
      params[:actual_lat] = -22.9068 # Rio de Janeiro (~360km)
      params[:actual_lng] = -43.1729
      
      post "/api/v1/events/#{event.id}/games/geoguessr/play", params: params, headers: headers
      
      json = JSON.parse(response.body)
      expect(json["score"]).to be < 5000
      expect(json["score"]).to be > 0
    end
  end
end
