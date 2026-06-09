class ApplicationMailer < ActionMailer::Base
  default from: -> { AppSetting.email_config['from_email'] || "birthday@example.com" }
  layout "mailer"

  def mail(headers = {}, &block)
    config = AppSetting.email_config
    
    # We pass the dynamic settings directly to the mail method
    # This works for both web and background jobs
    settings = {
      address:              config['smtp_address'] || 'mailpit',
      port:                 config['smtp_port'] || 1025,
      domain:               config['smtp_domain'] || 'localhost',
      user_name:            config['smtp_user_name'],
      password:             config['smtp_password'],
      enable_starttls_auto: config['smtp_enable_starttls_auto'] == '1' || config['smtp_enable_starttls_auto'] == true
    }

    if config['smtp_authentication'].present?
      settings[:authentication] = config['smtp_authentication'].to_sym
    end

    headers[:delivery_method_options] = settings.compact

    super
  end
end
