class BroadcastService
  def self.broadcast_event_status(event, status)
    message = {
      event_type: 'EVENT_STATUS_CHANGE',
      payload: {
        event_id: event.id,
        status: status,
        timestamp: Time.current.iso8601
      }
    }

    ActionCable.server.broadcast(
      "events:#{event.id}",
      message
    )
  end

  def self.broadcast_message(event, message)
    broadcast_data = {
      event_type: 'NEW_MESSAGE',
      payload: {
        id: message.id,
        content: message.content,
        message_type: message.message_type,
        sender_name: message.sender_name,
        created_at: message.created_at.iso8601
      }
    }

    ActionCable.server.broadcast(
      "events:#{event.id}",
      broadcast_data
    )
  end

  def self.broadcast_ranking_update(event)
    top_3 = event.rankings.order(total_score: :desc).limit(3).map do |r|
      {
        user_id: r.user_id,
        name: r.user.name,
        score: r.total_score
      }
    end

    message = {
      event_type: 'RANKING_UPDATE',
      payload: {
        top_3: top_3
      }
    }

    ActionCable.server.broadcast(
      "events:#{event.id}",
      message
    )
  end

  def self.broadcast_to_user(user, event_type, payload)
    message = {
      event_type: event_type,
      payload: payload
    }

    ActionCable.server.broadcast(
      "users:#{user.id}",
      message
    )
  end
end
