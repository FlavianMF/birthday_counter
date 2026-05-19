class ActiveEffect < ApplicationRecord
  # Validations
  validates :activated_at, presence: true

  # Associations
  belongs_to :event
  belongs_to :user
  belongs_to :shop_item

  # Scopes
  scope :active, -> { where(active: true).where('expires_at > ?', Time.current).or(where(expires_at: nil)) }
  scope :expired, -> { where('expires_at < ?', Time.current) }

  # Callbacks
  before_create :set_expiration

  def set_expiration
    if shop_item.duration_seconds
      self.expires_at = Time.current + shop_item.duration_seconds
    end
  end

  # Methods
  def is_active?
    active && (expires_at.nil? || expires_at > Time.current)
  end

  def expire!
    update!(active: false)
  end
end
