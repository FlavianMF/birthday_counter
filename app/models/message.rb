class Message < ApplicationRecord
  # Validations
  validates :event_id, presence: true
  validates :message_type, inclusion: { in: %w[text image video audio] }
  validates :status, inclusion: { in: %w[visible pending_approval hidden shadowbanned] }

  # Associations
  belongs_to :event
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id, optional: true
  has_many :reactions, dependent: :destroy

  # Scopes
  scope :visible, -> { where(status: 'visible') }
  scope :pending_approval, -> { where(status: 'pending_approval') }
  scope :hidden, -> { where(status: 'hidden') }
  scope :shadowbanned, -> { where(status: 'shadowbanned') }
  scope :revealed, -> { where(is_revealed: true) }
  scope :unrevealed, -> { where(is_revealed: false) }
  scope :for_event, ->(event_id) { where(event_id: event_id) }

  # Callbacks
  before_create :set_reveal_date

  def set_reveal_date
    self.reveal_date ||= event.target_date if event
  end

  def can_view?(user)
    # Shadowbanned messages only visible to sender
    return false if status == 'shadowbanned' && sender_id != user&.id
    # Hidden messages not visible
    return false if status == 'hidden'
    # Unrevealed messages only visible before climax to sender and admins
    if !is_revealed
      return true if user&.role == 'admin'
      return true if sender_id == user&.id
      return false
    end
    true
  end
end
