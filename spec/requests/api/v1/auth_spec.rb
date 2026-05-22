require 'rails_helper'

RSpec.describe "API::V1::Auth", type: :request do
  let(:valid_attributes) do
    {
      name: 'New User',
      email: 'new@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    }
  end

  describe "POST /api/v1/auth/register" do
    it "creates a new user and returns a token" do
      post "/api/v1/auth/register", params: { user: valid_attributes }
      
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["access_token"]).to be_present
      expect(json["user"]["email"]).to eq("new@example.com")
    end
  end

  describe "POST /api/v1/auth/login" do
    let!(:user) { create(:user, email: 'login@example.com', password: 'password123') }

    it "returns a token for valid credentials" do
      post "/api/v1/auth/login", params: { email: 'login@example.com', password: 'password123' }
      
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["access_token"]).to be_present
    end

    it "returns error for invalid credentials" do
      post "/api/v1/auth/login", params: { email: 'login@example.com', password: 'wrong' }
      
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
