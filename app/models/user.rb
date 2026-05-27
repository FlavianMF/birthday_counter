class User < ApplicationRecord
  has_secure_password

  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :role, inclusion: { in: %w[host guest sponsor admin] }

  # Associations
  has_many :hosted_events, class_name: 'Event', foreign_key: :host_id, dependent: :destroy
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

  # Level Logic
  def total_score
    rankings.sum(:total_score)
  end

  def level
    # Formula: level = floor(sqrt(total_score / 100)) + 1
    Math.sqrt(total_score / 100.0).floor + 1
  end

  def points_for_level(lvl)
    ((lvl - 1)**2) * 100
  end

  def points_to_next_level
    points_for_level(level + 1) - total_score
  end

  def level_progress_percentage
    current_level_base = points_for_level(level)
    next_level_base = points_for_level(level + 1)
    
    total_range = next_level_base - current_level_base
    current_progress = total_score - current_level_base
    
    (current_progress.to_f / total_range * 100).clamp(0, 100).to_i
  end
end
