class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    # Enable required extensions
    enable_extension 'uuid-ossp'
    enable_extension 'pg_trgm'

    # Users table
    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :name, null: false
      t.string :role, default: 'guest', null: false # 'host', 'guest', 'sponsor', 'admin'
      t.jsonb :profile_data, default: {}, null: false
      t.boolean :email_verified, default: false
      t.boolean :active, default: true
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :role
    add_index :users, :active

    # Events table
    create_table :events, id: :uuid do |t|
      t.uuid :host_id, null: false
      t.uuid :sponsor_id
      t.string :name, null: false
      t.string :description
      t.datetime :target_date, null: false
      t.string :status, default: 'active', null: false # 'active', 'climax', 'post_event', 'archived'
      t.string :access_code
      t.jsonb :config, default: {}, null: false
      t.boolean :is_surprise, default: false
      t.timestamps
    end

    add_index :events, :host_id
    add_index :events, :sponsor_id
    add_index :events, :status
    add_index :events, :target_date
    add_index :events, :access_code
    add_index :events, [:host_id, :status], where: "status = 'active'"

    # Event participants (join table)
    create_table :event_participants, id: :uuid do |t|
      t.uuid :event_id, null: false
      t.uuid :user_id, null: false
      t.string :role, default: 'guest', null: false # 'host', 'sponsor', 'guest'
      t.boolean :has_accepted, default: false
      t.timestamps
    end

    add_index :event_participants, :event_id
    add_index :event_participants, :user_id
    add_index :event_participants, [:event_id, :user_id], unique: true

    # Messages table (for capsule messages)
    create_table :messages, id: :uuid do |t|
      t.uuid :event_id, null: false
      t.uuid :sender_id
      t.string :sender_name
      t.text :content
      t.string :message_type, default: 'text', null: false # 'text', 'image', 'video', 'audio'
      t.string :media_url
      t.boolean :is_revealed, default: false, null: false
      t.datetime :reveal_date
      t.string :status, default: 'visible', null: false # 'visible', 'pending_approval', 'hidden', 'shadowbanned'
      t.integer :likes_count, default: 0
      t.timestamps
    end

    add_index :messages, :event_id
    add_index :messages, :sender_id
    add_index :messages, :is_revealed
    add_index :messages, [:event_id, :is_revealed]
    add_index :messages, :status

    # Rankings table
    create_table :rankings, id: :uuid do |t|
      t.uuid :event_id, null: false
      t.uuid :user_id, null: false
      t.integer :total_score, default: 0, null: false
      t.integer :coins, default: 0, null: false
      t.integer :streak_days, default: 0, null: false
      t.datetime :last_activity_date
      t.timestamps
    end

    add_index :rankings, :event_id
    add_index :rankings, :user_id
    add_index :rankings, [:event_id, :total_score], order: { total_score: :desc }
    add_index :rankings, [:event_id, :user_id], unique: true

    # Coin transactions
    create_table :coin_transactions, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :event_id
      t.integer :amount, null: false
      t.string :transaction_type, null: false # 'earned', 'spent'
      t.string :source # 'geoguessr', 'fact_or_fiction', 'timeline', 'shop_purchase', 'streak_bonus'
      t.string :description
      t.timestamps
    end

    add_index :coin_transactions, :user_id
    add_index :coin_transactions, :event_id
    add_index :coin_transactions, :transaction_type

    # Game sessions
    create_table :game_sessions, id: :uuid do |t|
      t.uuid :event_id, null: false
      t.uuid :user_id, null: false
      t.string :game_type, null: false # 'geoguessr', 'fact_or_fiction', 'timeline_reorder'
      t.integer :score, default: 0
      t.jsonb :game_data, default: {}
      t.datetime :completed_at
      t.timestamps
    end

    add_index :game_sessions, :event_id
    add_index :game_sessions, :user_id
    add_index :game_sessions, :game_type

    # Media repository (for timeline game and memories)
    create_table :media_repository, id: :uuid do |t|
      t.uuid :event_id, null: false
      t.uuid :uploader_id
      t.string :media_type, null: false # 'image', 'video', 'audio'
      t.string :url, null: false
      t.string :thumbnail_url
      t.datetime :date_taken
      t.jsonb :metadata, default: {}
      t.string :caption
      t.timestamps
    end

    add_index :media_repository, :event_id
    add_index :media_repository, :uploader_id
    add_index :media_repository, :media_type

    # Shop items (effects that can be purchased with coins)
    create_table :shop_items, id: :uuid do |t|
      t.string :name, null: false
      t.string :description
      t.integer :cost, null: false
      t.string :item_type, null: false # 'effect', 'feature'
      t.string :effect_name # e.g., 'emoji_rain', 'music_priority', 'reveal_media'
      t.integer :duration_seconds # for temporary effects
      t.boolean :active, default: true
      t.timestamps
    end

    add_index :shop_items, :item_type
    add_index :shop_items, :active

    # Active effects (purchased and activated)
    create_table :active_effects, id: :uuid do |t|
      t.uuid :event_id, null: false
      t.uuid :user_id, null: false
      t.uuid :shop_item_id, null: false
      t.datetime :activated_at, null: false
      t.datetime :expires_at
      t.boolean :active, default: true
      t.timestamps
    end

    add_index :active_effects, :event_id
    add_index :active_effects, :user_id
    add_index :active_effects, :active

    # Admin audit logs
    create_table :audit_logs, id: :uuid do |t|
      t.uuid :admin_id
      t.string :action, null: false
      t.string :resource_type
      t.uuid :resource_id
      t.jsonb :metadata, default: {}
      t.timestamps
    end

    add_index :audit_logs, :admin_id
    add_index :audit_logs, :action
    add_index :audit_logs, [:resource_type, :resource_id]

    # Add constraints
    add_check_constraint :coin_transactions, 'amount <> 0', name: 'check_amount_not_zero'
    add_check_constraint :rankings, 'total_score >= 0', name: 'check_score_non_negative'
    add_check_constraint :events, 'target_date > created_at', name: 'check_target_date_future'
  end
end
