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
  end
end
