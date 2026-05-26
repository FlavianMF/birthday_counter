require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  describe "POST /registrations" do
    let(:event) { create(:event, :surprise, host: nil, invitation_token: 'GIFT-123') }
    let(:valid_params) do
      {
        user: {
          name: 'New Host',
          email: 'newhost@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    context "with a pending invitation token in session" do
      before do
        # Use POST because the claim route is a POST route
        post claim_invitation_path(event.invitation_token)
      end

      it "claims the event for the newly registered user" do
        expect {
          post register_path, params: valid_params
        }.to change(User, :count).by(1)

        user = User.last
        event.reload
        
        expect(event.host).to eq(user)
        expect(event.invitation_token).to be_nil
        expect(response).to redirect_to(event_path(event))
      end
    end

    context "without a pending invitation token" do
      it "registers the user and redirects to events list" do
        expect {
          post register_path, params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(events_path)
      end
    end
  end
end
