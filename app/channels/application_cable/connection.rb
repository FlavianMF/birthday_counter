class ApplicationCable::Connection < ActionCable::Connection::Base
  identified_by :current_user_id, :current_event_id

  def connect
    self.current_user_id = verify_user
    self.current_event_id = params[:event_id]
    reject_unauthorized_connection unless current_user_id

    # Join event room
    StreamForEvent if current_event_id
  end

  private

  def verify_user
    token = params[:token]
    return nil unless token

    begin
      payload = JwtDecoder.decode(token)
      payload['user_id']
    rescue
      nil
    end
  end
end
