require "rails_helper"

RSpec.describe NotificationService do
  describe ".send_daily_countdowns" do
    let!(:event) { create(:event, target_date: 3.days.from_now, status: "active") }
    let!(:participant) { create(:user) }
    let!(:event_participant) { create(:event_participant, event: event, user: participant) }

    it "enqueues countdown emails for participants" do
      expect {
        NotificationService.send_daily_countdowns
      }.to have_enqueued_mail(NotificationMailer, :countdown_email).with(participant, event)
    end
  end

  describe ".send_event_invitation" do
    let(:event) { create(:event, is_surprise: true, recipient_email: "test@example.com", invitation_token: "abc") }

    it "enqueues invitation email" do
      expect {
        NotificationService.send_event_invitation(event)
      }.to have_enqueued_mail(NotificationMailer, :invitation_email).with("test@example.com", event)
    end
  end
end
