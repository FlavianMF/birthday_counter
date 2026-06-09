require 'rails_helper'

RSpec.describe SystemSettingsController, type: :request do
  let(:admin) { create(:user, role: 'admin') }
  let(:user) { create(:user, role: 'guest') }

  describe "GET /settings/email" do
    context "when admin" do
      before { login_as(admin) }

      it "returns success" do
        get email_settings_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "when guest" do
      before { login_as(user) }

      it "redirects to root" do
        get email_settings_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /settings/email" do
    before { login_as(admin) }

    let(:settings_params) do
      {
        settings: {
          smtp_enabled: 'true',
          address: 'smtp.test.com',
          port: '587',
          from_email: 'noreply@test.com'
        }
      }
    end

    it "updates the settings and applies them" do
      patch email_settings_path, params: settings_params
      expect(response).to redirect_to(email_settings_path)
      
      setting = SystemSetting.find_by(category: 'email')
      expect(setting.settings['address']).to eq('smtp.test.com')
      expect(ActionMailer::Base.smtp_settings[:address]).to eq('smtp.test.com')
    end
  end
end
