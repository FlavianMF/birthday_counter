class NotificationService
  def self.send_daily_countdowns
    Event.active.upcoming.find_each do |event|
      # Send to all participants
      event.participants.find_each do |participant|
        NotificationMailer.countdown_email(participant, event).deliver_later
      end
      
      # Also send to host if not already in participants
      if event.host && !event.participants.include?(event.host)
        NotificationMailer.countdown_email(event.host, event).deliver_later
      end
    end
  end

  def self.send_event_invitation(event)
    return unless event.is_surprise? && event.recipient_email.present? && event.invitation_token.present?

    NotificationMailer.invitation_email(event.recipient_email, event).deliver_later
  end

  def self.invite_guest(email, event, inviter)
    NotificationMailer.guest_invitation_email(email, event, inviter).deliver_later
  end
end
