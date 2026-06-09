class ApplicationController < ActionController::Base
  before_action :set_mailer_settings

  # Prevent CSRF attacks
  skip_forgery_protection if: -> { Rails.env.test? }
  
  # Helper methods
  helper_method :current_user, :logged_in?, :current_user_coins, :current_user_total_score
  
  private
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    current_user.present?
  end
  
  def require_login
    unless logged_in?
      redirect_to login_path, alert: "Você precisa estar logado para acessar esta página"
    end
  end

  def require_admin
    require_login
    return if performed?
    
    unless current_user.role == 'admin'
      redirect_to root_path, alert: "Você não tem permissão para acessar esta página"
    end
  end
  
  def current_user_coins
    return 0 unless logged_in?
    # Get total coins across all events for the user
    Ranking.where(user: current_user).sum(:coins)
  end

  def current_user_total_score
    return 0 unless logged_in?
    # Get total score across all events for the user
    Ranking.where(user: current_user).sum(:total_score)
  end

  private

  def set_mailer_settings
    config = AppSetting.email_config
    ActionMailer::Base.smtp_settings = {
      address: config['smtp_address'] || 'mailpit',
      port: config['smtp_port'] || 1025
    }
  end
end
