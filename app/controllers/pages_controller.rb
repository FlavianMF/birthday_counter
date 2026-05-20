class PagesController < ApplicationController
  def home
    @events = Event.includes(:host).where(status: 'active').order(:target_date).limit(5) if logged_in?
    
    # Fetch the current user's main event (closest upcoming event)
    if logged_in?
      @main_event = current_user.hosted_events.active.upcoming.first || 
                    current_user.events.joins(:event_participants).where(event_participants: { user_id: current_user.id }).active.upcoming.first
    end
  end
end
