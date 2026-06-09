require 'rails_helper'

RSpec.describe "API::V1::EventInvitations", type: :request do
  let(:user) { create(:user) }
  let(:event) { create(:event, host: user) }
  let(:headers) { auth_headers(user) }

  describe "POST /api/v1/events/:id/invite" do
    context "with valid email" do
      it "enqueues the invitation email and returns success" do
        expect {
          post "/api/v1/events/#{event.id}/invite", params: { email: 'guest@example.com' }, headers: headers
        }.to have_enqueued_mail(NotificationMailer, :guest_invitation_email).with('guest@example.com', event, user)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq("Invitation sent to guest@example.com")
      end
    end

    context "with invalid email" do
      it "returns error" do
        post "/api/v1/events/#{event.id}/invite", params: { email: 'invalid-email' }, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('bad_request')
      end
    end
  end
end
