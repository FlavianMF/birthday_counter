class GamesController < ApplicationController
  before_action :require_login
  before_action :set_event, only: [:index, :fact_or_fiction]

  def index
    if @event
      # Viewing games for a specific event
      @events = [@event]
    else
      # Global games page - list all active events for the user
      @events = current_user.hosted_events.or(Event.where(sponsor_id: current_user.id)).active
    end
  end
  
  def show
  end

  def fact_or_fiction
    @ranking = Ranking.find_or_create_by!(event: @event, user: current_user)
    
    # Check if custom content exists
    custom_game = @event.game_config.dig('fact_or_fiction')
    if custom_game && custom_game['fiction'].present? && custom_game['facts'].reject(&:blank?).size >= 2
      @game_data = {
        facts: custom_game['facts'].reject(&:blank?),
        fiction: custom_game['fiction']
      }
    else
      bio = @event.host&.profile_data&.[]('bio_storytelling') || "Host adora festas e games!"
      @game_data = AiModerationService.generate_fact_or_fiction(bio)
    end
    
    @statements = (@game_data[:facts] + [@game_data[:fiction]]).shuffle
  end

  def play
    @event = Event.find(params[:event_id])
    @ranking = Ranking.find_or_create_by!(event: @event, user: current_user)
    
    is_correct = params[:is_correct] == true || params[:is_correct] == "true"
    base_score = is_correct ? 500 : 0
    
    # Use transaction to ensure data consistency
    ActiveRecord::Base.transaction do
      result = @ranking.add_score(base_score)
      @score = result[:points]
      @coins_earned = result[:coins]
      
      if is_correct && @coins_earned > 0
        # Ensure coins are added to the transaction as well
        CoinTransaction.create!(
          user: current_user,
          event: @event,
          amount: @coins_earned,
          transaction_type: 'earned',
          source: 'fact_or_fiction',
          description: "Fact or Fiction: correct answer (Multiplier: #{result[:multiplier]}x)"
        )
      end

      # Record game session for analytics/history
      GameSession.create!(
        event: @event,
        user: current_user,
        game_type: 'fact_or_fiction',
        score: @score,
        game_data: { is_correct: is_correct, multiplier: result[:multiplier] },
        completed_at: Time.current
      )
    end

    BroadcastService.broadcast_ranking_update(@event)
    # add_score already broadcasts user stats, but we can be explicit if needed
    # BroadcastService.broadcast_user_stats(current_user)

    render json: {
      score: @score,
      coins_earned: @coins_earned,
      is_correct: is_correct,
      new_total_score: @ranking.total_score,
      rank_position: @ranking.rank_position
    }
  end

  private

  def set_event
    @event = Event.find_by(id: params[:event_id])
  end
end
