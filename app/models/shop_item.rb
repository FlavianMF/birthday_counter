class ShopItem < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :cost, presence: true, numericality: { greater_than: 0 }
  validates :item_type, inclusion: { in: %w[effect feature] }

  # Associations
  has_many :active_effects, dependent: :destroy

  # Scopes
  scope :active, -> { where(active: true) }
  scope :effects, -> { where(item_type: 'effect') }
  scope :features, -> { where(item_type: 'feature') }

  # Predefined shop items
  def self.emoji_rain
    find_or_create_by!(name: 'Emoji Rain', defaults: {
      description: 'Show emoji rain for everyone in the event',
      cost: 500,
      item_type: 'effect',
      effect_name: 'emoji_rain',
      duration_seconds: 600 # 10 minutes
    })
  end

  def self.music_priority
    find_or_create_by!(name: 'Music Priority', defaults: {
      description: 'Move your song to the top of the queue',
      cost: 1000,
      item_type: 'effect',
      effect_name: 'music_priority',
      duration_seconds: nil
    })
  end

  def self.reveal_media
    find_or_create_by!(name: 'Reveal Media VIP', defaults: {
      description: 'Unlock a rare photo from the event',
      cost: 5000,
      item_type: 'effect',
      effect_name: 'reveal_media',
      duration_seconds: nil
    })
  end
end
