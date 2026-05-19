class EventChannel < ApplicationCable::Channel
  def subscribed
    # Stream from event-specific channel
    stream_from "events:#{params[:event_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    # Handle incoming messages if needed
  end
end
