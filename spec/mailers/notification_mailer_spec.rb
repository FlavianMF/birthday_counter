require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "countdown_email" do
    let(:user) { create(:user, name: "John Doe", email: "john@example.com") }
    let(:event) { create(:event, name: "Party", target_date: 5.days.from_now) }
    let(:mail) { NotificationMailer.countdown_email(user, event) }

    it "renders the headers" do
      expect(mail.subject).to eq("🎂 5 dias para o aniversário de Party!")
      expect(mail.to).to eq(["john@example.com"])
      expect(mail.from).to eq(["birthday@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Olá John Doe")
      expect(mail.body.encoded).to match("Faltam apenas <strong>5</strong> dias")
    end
  end

  describe "invitation_email" do
    let(:event) { create(:event, name: "Surprise", invitation_token: "token123", is_surprise: true) }
    let(:mail) { NotificationMailer.invitation_email("recipient@example.com", event) }

    it "renders the headers" do
      expect(mail.subject).to eq("🎁 Você recebeu um presente surpresa: O aniversário de Surprise!")
      expect(mail.to).to eq(["recipient@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Surpresa!")
      expect(mail.body.encoded).to match("Reivindicar meu Aniversário")
      expect(mail.body.encoded).to match("/invite/token123")
    end
  end
end
