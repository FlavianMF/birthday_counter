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
    update_streak!
    multiplier = streak_multiplier
    earned_points = (points * multiplier).to_i
    earned_coins = (earned_points / 10.0).to_i
    
    self.total_score += earned_points
    self.coins += earned_coins
    save!
    
    BroadcastService.broadcast_user_stats(user)
    
    { points: earned_points, coins: earned_coins, multiplier: multiplier }
  end

  def update_streak!
    today = Date.current
    last_date = last_activity_date&.to_date
    
    if last_date.nil?
      self.streak_days = 1
    elsif last_date == today
      # Already active today
    elsif last_date == today - 1.day
      self.streak_days += 1
    else
      # Streak broken
      self.streak_days = 1
    end
    
    self.last_activity_date = Time.current
    # We don't save here yet because add_score will save
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
    if event_id.present?
      Ranking.where(event_id: event_id)
             .where('total_score > ?', total_score)
             .count + 1
    else
      # Global rank calculation (summing all rankings per user)
      # This is expensive, so we might want to cache it or use a simpler approach
      # For now, a query that mirrors the RankingsController logic
      subquery = Ranking.group(:user_id).select('SUM(total_score) as total')
      Ranking.from(subquery, :user_totals)
             .where('total > ?', total_score)
             .count + 1
    end
  end
end
