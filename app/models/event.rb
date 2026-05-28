class Event < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :target_date, presence: true
  validates :status, inclusion: { in: %w[active climax post_event archived] }
  validates :invitation_token, uniqueness: true, allow_nil: true
  validates :recipient_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validate :target_date_must_be_in_the_future, on: :create
  validate :host_presence_unless_surprise

  # Associations
  belongs_to :host, class_name: 'User', foreign_key: :host_id, optional: true
  belongs_to :sponsor, class_name: 'User', foreign_key: :sponsor_id, optional: true
  has_many :event_participants, dependent: :destroy
  has_many :participants, through: :event_participants, source: :user
  has_many :messages, dependent: :destroy
  has_many :rankings, dependent: :destroy
  has_many :coin_transactions, dependent: :destroy
  has_many :game_sessions, dependent: :destroy
  has_many :media_items, class_name: 'MediaRepository', dependent: :destroy
  has_many :active_effects, dependent: :destroy

  # Callbacks
  before_create :generate_access_code
  before_create :generate_invitation_token, if: -> { is_surprise? && host_id.nil? }
  after_create :send_invitation_email, if: -> { is_surprise? && recipient_email.present? }
  after_initialize :set_default_configs

  def send_invitation_email
    NotificationService.send_event_invitation(self)
  end

  def generate_invitation_token
    self.invitation_token = SecureRandom.urlsafe_base64(16)
  end

  def host_presence_unless_surprise
    if !is_surprise? && host_id.blank?
      errors.add(:host_id, "must be present if the event is not a surprise")
    end
  end

  def claim_by!(user)
    transaction do
      update!(
        host_id: user.id,
        invitation_token: nil,
        invitation_claimed_at: Time.current
      )
      # Also add as participant with host role if not already there
      event_participants.find_or_create_by!(user: user) do |p|
        p.role = 'host'
        p.has_accepted = true
      end
    end
  end

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :climax, -> { where(status: 'climax') }
  scope :post_event, -> { where(status: 'post_event') }
  scope :archived, -> { where(status: 'archived') }
  scope :upcoming, -> { where('target_date > ?', Time.current).order(:target_date) }
  scope :completed, -> { where('target_date < ?', Time.current).order(:target_date) }

  # JSONB config defaults
  def config
    super || {}
  end

  def game_config
    super || {}
  end

  def set_default_configs
    self.config ||= {
      'theme_id' => nil,
      'vfx_enabled' => true,
      'ai_complexity' => 'medium',
      'spotify_playlist_id' => nil,
      'milestones' => []
    }
    self.game_config ||= {
      'fact_or_fiction' => {
        'facts' => [],
        'fiction' => nil
      }
    }
  end

  def generate_access_code
    self.access_code = SecureRandom.alphanumeric(8).upcase
  end

  def target_date_must_be_in_the_future
    if target_date && target_date <= Time.current
      errors.add(:target_date, 'deve ser uma data futura')
    end
  end

  # State transitions
  def transition_to_climax!
    update!(status: 'climax')
    # Emit WebSocket event
    BroadcastService.broadcast_event_status(self, 'CLIMAX')
    # Reveal all messages
    messages.where(is_revealed: false).update_all(is_revealed: true)
  end

  def transition_to_post_event!
    update!(status: 'post_event')
    BroadcastService.broadcast_event_status(self, 'POST_EVENT')
  end

  def transition_to_archived!
    update!(status: 'archived')
  end

  # Check if event should transition to climax
  def should_be_climax?
    target_date <= Time.current && status == 'active'
  end
end
