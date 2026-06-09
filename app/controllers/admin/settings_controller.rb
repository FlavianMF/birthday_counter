class Admin::SettingsController < ApplicationController
  def email
    @config = AppSetting.email_config
  end

  def update_email
    AppSetting.set('email_config', email_params.to_h)
    redirect_to admin_email_settings_path, notice: 'Configurações de email atualizadas!'
  end

  private

  def email_params
    params.require(:config).permit(:smtp_address, :smtp_port, :from_email, :smtp_domain, :smtp_user_name, :smtp_password, :smtp_authentication, :smtp_enable_starttls_auto)
  end
end
