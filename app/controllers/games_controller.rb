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
    base_score = 500
    
    # Store session to prevent multiple plays per game if desired
    # For now, let's just make sure it's working
    
    if is_correct
      score = base_score
      @ranking.add_score(score)
      
      # Ensure coins are added to the transaction as well
      coins_earned = (score / 10.0).to_i
      
      CoinTransaction.create!(
        user: current_user,
        event: @event,
        amount: coins_earned,
        transaction_type: 'earned',
        source: 'fact_or_fiction',
        description: "Fact or Fiction: correct answer"
      )

      # Record game session for analytics/history
      GameSession.create!(
        event: @event,
        user: current_user,
        game_type: 'fact_or_fiction',
        score: score,
        game_data: { is_correct: true },
        completed_at: Time.current
      )
    else
      score = 0
      GameSession.create!(
        event: @event,
        user: current_user,
        game_type: 'fact_or_fiction',
        score: 0,
        game_data: { is_correct: false },
        completed_at: Time.current
      )
    end

    BroadcastService.broadcast_ranking_update(@event)

    render json: {
      score: score,
      coins_earned: is_correct ? (score / 10).to_i : 0,
      is_correct: is_correct,
      new_total_score: @ranking.total_score
    }
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
