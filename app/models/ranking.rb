class Ranking < ApplicationRecord
  # Validations
  validates :total_score, numericality: { greater_than_or_equal_to: 0 }
  validates :coins, numericality: true
  validates :streak_days, numericality: { greater_than_or_equal_to: 0 }

  # Associations
  belongs_to :event
  belongs_to :user

  # Scopes
  scope :top_10, -> { order(total_score: :desc).limit(10) }
  scope :for_event, ->(event_id) { where(event_id: event_id) }

  # Methods
  def streak_multiplier
    return 2.0 if streak_days >= 7
    return 1.5 if streak_days >= 3
    1.0
  end

  def add_score(points)
    multiplier = streak_multiplier
    self.total_score += (points * multiplier).to_i
    # Award coins based on points (1 coin for every 10 points)
    self.coins += (points / 10.0).to_i
    save!
  end

  def add_coins(coins)
    self.coins += coins
    save!
  end

  def spend_coins(coins)
    return false if self.coins < coins
    self.coins -= coins
    save!
  end

  def rank_position
    Ranking.where(event_id: event_id)
           .where('total_score > ?', total_score)
           .count + 1
  end
end
