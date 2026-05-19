class GameSession < ApplicationRecord
  # Validations
  validates :game_type, inclusion: {
    in: %w[geoguessr fact_or_fiction timeline_reorder]
  }

  # Associations
  belongs_to :event
  belongs_to :user

  # Scopes
  scope :for_event, ->(event_id) { where(event_id: event_id) }
  scope :for_user, ->(user_id) { where(user_id: user_id) }
  scope :completed, -> { where.not(completed_at: nil) }

  # Methods
  def complete!(score, game_data = {})
    self.score = score
    self.game_data = game_data
    self.completed_at = Time.current
    save!
  end
end
