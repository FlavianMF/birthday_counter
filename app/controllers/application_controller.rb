class ApplicationController < ActionController::Base
  # Prevent CSRF attacks
  protect_from_forgery with: :exception
  
  # Helper methods
  helper_method :current_user, :logged_in?
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    @current_user.present?
  end
  
  def require_login
    unless logged_in?
      redirect_to login_path, alert: "Você precisa estar logado para acessar esta página"
    end
  end
  
  def current_user_coins
    return 0 unless logged_in?
    Ranking.find_by(user: current_user, event: nil)&.coins || 0
  end
end
