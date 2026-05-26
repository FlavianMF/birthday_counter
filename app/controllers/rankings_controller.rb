class RankingsController < ApplicationController
  before_action :set_event

  def index
    if @event
      @rankings = @event.rankings.includes(:user).order(total_score: :desc)
    else
      # Global ranking (aggregate or list events?)
      # For now, let's show global top users across all events
      @rankings = Ranking.includes(:user).order(total_score: :desc).limit(50)
    end
    
    @top_3 = @rankings.limit(3).to_a
    @current_user_ranking = @rankings.find_by(user: current_user) if logged_in?
  end

  private

  def set_event
    @event = Event.find_by(id: params[:event_id])
  end
end
