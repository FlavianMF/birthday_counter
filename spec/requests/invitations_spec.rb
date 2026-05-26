require 'rails_helper'

RSpec.describe "Host Invitation Flow", type: :request do
  let(:sponsor) { create(:user, role: 'sponsor') }
  let(:host_candidate) { create(:user, role: 'guest') }

  describe "Sponsor creates a surprise event" do
    before { login_as(sponsor) }

    it "creates an event with an invitation token and no host" do
      post events_path, params: { 
        event: { 
          name: "Surprise Party", 
          target_date: 1.month.from_now, 
          is_surprise: true 
        } 
      }
      
      event = Event.last
      expect(event.is_surprise).to be true
      expect(event.sponsor_id).to eq(sponsor.id)
      expect(event.host_id).to be_nil
      expect(event.invitation_token).not_to be_nil

      # Verify visibility in index
      get events_path
      expect(response.body).to include(event.name)
    end
  end

  describe "Host candidate claims the event" do
    let(:event) { create(:event, :surprise, sponsor: sponsor, host: nil) }

    context "when logged in" do
      before { login_as(host_candidate) }

      it "claims the event successfully" do
        post claim_invitation_path(event.invitation_token)
        
        event.reload
        expect(event.host_id).to eq(host_candidate.id)
        expect(event.invitation_token).to be_nil
        expect(response).to redirect_to(event_path(event))
      end
    end

    context "when not logged in" do
      it "redirects to register and remembers the token" do
        post claim_invitation_path(event.invitation_token)
        expect(response).to redirect_to(register_path)
        expect(session[:pending_invitation_token]).to eq(event.invitation_token)
      end
    end
  end
end
