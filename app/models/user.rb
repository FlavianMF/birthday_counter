class User < ApplicationRecord
  has_secure_password

  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :role, inclusion: { in: %w[host guest sponsor admin] }

  # Associations
  has_many :hosted_events, -> { where(role: 'host') },
           through: :event_participants, source: :event
  has_many :event_participants, dependent: :destroy
  has_many :events, through: :event_participants
  has_many :messages, foreign_key: :sender_id, dependent: :nullify
  has_many :rankings, dependent: :destroy
  has_many :coin_transactions, dependent: :destroy
  has_many :game_sessions, dependent: :destroy
  has_many :uploaded_media, class_name: 'MediaRepository', foreign_key: :uploader_id, dependent: :nullify
  has_many :active_effects, dependent: :destroy
  has_many :audit_logs, foreign_key: :admin_id, dependent: :nullify

  # JSONB profile_data defaults
  def profile_data
    super || {}
  end

  def full_name
    name
  end

  def avatar_url
    profile_data['avatar_url']
  end

  # Scope for active users
  scope :active, -> { where(active: true) }

  # Scope for verified users
  scope :verified, -> { where(email_verified: true) }
end
