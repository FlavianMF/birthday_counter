class RankingsController < ApplicationController
  before_action :set_event

  def index
    if @event
      @rankings = @event.rankings.includes(:user).order(total_score: :desc)
      @top_3 = @rankings.limit(3).to_a
    else
      # Global ranking - Sum points per user
      # This is more complex because we need to sum across events
      @rankings = Ranking.joins(:user)
                         .group('users.id', 'users.name')
                         .select('users.id, users.name as user_name, SUM(total_score) as total_score, MAX(streak_days) as streak_days')
                         .order('total_score DESC')
                         .limit(50)
                         
      # Map to match expected ranking interface
      @rankings = @rankings.map do |r|
        OpenStruct.new(user: OpenStruct.new(id: r.id, name: r.user_name), total_score: r.total_score, streak_days: r.streak_days)
      end
      
      @top_3 = @rankings.first(3)
    end
    
    if logged_in?
      if @event
        @current_user_ranking = Ranking.find_or_create_by!(event: @event, user: current_user)
      else
        # For global ranking, we just show the sum of all rankings
        # We can use a mock object or just calculate values
        @current_user_ranking = Ranking.new(
          user: current_user, 
          total_score: current_user_total_score,
          coins: current_user_coins
        )
      end
    end
  end

  private

  def set_event
    @event = Event.find_by(id: params[:event_id])
  end
end
