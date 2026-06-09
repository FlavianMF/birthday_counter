class SystemSetting < ApplicationRecord
  validates :category, presence: true, uniqueness: true
  validates :settings, presence: true

  def self.email_settings
    find_by(category: 'email')&.settings || {}
  end

  def self.apply_email_settings!
    config = email_settings
    return if config.blank?

    # SMTP Settings
    if config['smtp_enabled'] == 'true' || config['smtp_enabled'] == true
      ActionMailer::Base.delivery_method = :smtp
      ActionMailer::Base.smtp_settings = {
        address:              config['address'],
        port:                 config['port'],
        domain:               config['domain'],
        user_name:            config['user_name'],
        password:             config['password'],
        authentication:       config['authentication'] || 'plain',
        enable_starttls_auto: config['enable_starttls_auto'].nil? ? true : config['enable_starttls_auto']
      }.compact
    end

    # Default From Address
    if config['from_email'].present?
      ActionMailer::Base.default_options = { from: config['from_email'] }
    end
  end
end
