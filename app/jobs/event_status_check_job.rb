class EventStatusCheckJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Find events that should transition to climax
    Event.active.each do |event|
      if event.should_be_climax?
        event.transition_to_climax!
      end
    end

    # Find events that should transition to post_event (24 hours after target)
    Event.climax.each do |event|
      if event.target_date + 24.hours <= Time.current
        event.transition_to_post_event!
      end
    end

    # Auto-archiving: Archive events 7 days after target_date if status is still 'active' or 'post_event'
    Event.where(status: ['active', 'post_event']).where('target_date + ? <= ?', 7.days, Time.current).each do |event|
      if event.status == 'active' && event.sponsor.present?
        # Notify sponsor that party was never activated
        # In a real app, this would call a mailer or notification service
        Rails.logger.info "Notifying sponsor #{event.sponsor.email} that event #{event.name} was never activated."
      end
      event.transition_to_archived!
    end
  end
end
