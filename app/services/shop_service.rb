class ShopService
  def self.buy_item(user:, event:, shop_item:)
    ranking = Ranking.find_by(user: user, event: event)
    
    return { success: false, error: 'no_ranking' } unless ranking
    return { success: false, error: 'insufficient_funds' } if ranking.coins < shop_item.cost
    
    lock_key = "shop_lock_#{event.id}_#{shop_item.id}"
    redis = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'))
    
    # Try to acquire lock for 5 seconds
    if redis.set(lock_key, "locked", nx: true, ex: 5)
      begin
        ActiveRecord::Base.transaction do
          # Atomic deduction
          ranking.lock!
      if ranking.coins >= shop_item.cost
        ranking.coins -= shop_item.cost
        ranking.save!
        
        # Prevent overlapping effects of the same type if configured
        # (Assuming item_type determines overlap for now)
        ActiveEffect.where(event: event, active: true)
                    .joins(:shop_item)
                    .where(shop_items: { item_type: shop_item.item_type })
                    .update_all(active: false, expires_at: Time.current)

        # Create effect
        effect = ActiveEffect.create!(
          event: event,
          user: user,
          shop_item: shop_item,
          activated_at: Time.current,
          expires_at: Time.current + (shop_item.duration_seconds || 600).seconds,
          active: true
        )

        # Record transaction
        CoinTransaction.create!(
          user: user,
          event: event,
          amount: -shop_item.cost,
          transaction_type: 'spent',
          source: 'shop',
          description: "Purchased #{shop_item.name}"
        )

        # Broadcast effect activation
        BroadcastService.broadcast_to_user(user, 'EFFECT_ACTIVATED', {
          effect_id: effect.id,
          name: shop_item.name,
          expires_at: effect.expires_at
        })

        return { success: true, effect: effect }
      else
        raise ActiveRecord::Rollback
      end
    end
      ensure
        # Release lock
        redis.del(lock_key)
      end
    else
      return { success: false, error: 'item_locked' }
    end
  rescue => e
    Rails.logger.error "Shop purchase failed: #{e.message}"
    { success: false, error: 'transaction_failed' }
  end
end
