class ApplicationController < ActionController::Base
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
end
