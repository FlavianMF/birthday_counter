class SystemSettingsController < ApplicationController
  before_action :require_admin

  def email
    @setting = SystemSetting.find_or_initialize_by(category: 'email')
  end

  def update_email
    @setting = SystemSetting.find_or_initialize_by(category: 'email')
    
    if @setting.update(settings: email_params)
      SystemSetting.apply_email_settings!
      AuditLog.log_action(current_user.id, 'update_email_settings', 'SystemSetting', @setting.id, email_params)
      redirect_to email_settings_path, notice: "Configurações de email atualizadas com sucesso."
    else
      render :email, status: :unprocessable_entity
    end
  end

  private

  def email_params
    params.require(:settings).permit(
      :smtp_enabled, :address, :port, :domain, 
      :user_name, :password, :authentication, 
      :enable_starttls_auto, :from_email
    )
  end
end
