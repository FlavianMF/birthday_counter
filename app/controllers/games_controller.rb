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

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
