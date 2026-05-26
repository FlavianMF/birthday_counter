# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_05_26_224921) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_effects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.uuid "user_id", null: false
    t.uuid "shop_item_id", null: false
    t.datetime "activated_at", null: false
    t.datetime "expires_at"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_active_effects_on_active"
    t.index ["event_id"], name: "index_active_effects_on_event_id"
    t.index ["user_id"], name: "index_active_effects_on_user_id"
  end

  create_table "audit_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "admin_id"
    t.string "action", null: false
    t.string "resource_type"
    t.uuid "resource_id"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action"], name: "index_audit_logs_on_action"
    t.index ["admin_id"], name: "index_audit_logs_on_admin_id"
    t.index ["resource_type", "resource_id"], name: "index_audit_logs_on_resource_type_and_resource_id"
  end

  create_table "coin_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "event_id"
    t.integer "amount", null: false
    t.string "transaction_type", null: false
    t.string "source"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_coin_transactions_on_event_id"
    t.index ["transaction_type"], name: "index_coin_transactions_on_transaction_type"
    t.index ["user_id"], name: "index_coin_transactions_on_user_id"
    t.check_constraint "amount <> 0", name: "check_amount_not_zero"
  end

  create_table "event_participants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.uuid "user_id", null: false
    t.string "role", default: "guest", null: false
    t.boolean "has_accepted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "user_id"], name: "index_event_participants_on_event_id_and_user_id", unique: true
    t.index ["event_id"], name: "index_event_participants_on_event_id"
    t.index ["user_id"], name: "index_event_participants_on_user_id"
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "host_id"
    t.uuid "sponsor_id"
    t.string "name", null: false
    t.string "description"
    t.datetime "target_date", null: false
    t.string "status", default: "active", null: false
    t.string "access_code"
    t.jsonb "config", default: {}, null: false
    t.boolean "is_surprise", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_claimed_at"
    t.index ["access_code"], name: "index_events_on_access_code"
    t.index ["host_id", "status"], name: "index_events_on_host_id_and_status", where: "((status)::text = 'active'::text)"
    t.index ["host_id"], name: "index_events_on_host_id"
    t.index ["invitation_token"], name: "index_events_on_invitation_token"
    t.index ["sponsor_id"], name: "index_events_on_sponsor_id"
    t.index ["status"], name: "index_events_on_status"
    t.index ["target_date"], name: "index_events_on_target_date"
    t.check_constraint "target_date > created_at", name: "check_target_date_future"
  end

  create_table "game_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.uuid "user_id", null: false
    t.string "game_type", null: false
    t.integer "score", default: 0
    t.jsonb "game_data", default: {}
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_game_sessions_on_event_id"
    t.index ["game_type"], name: "index_game_sessions_on_game_type"
    t.index ["user_id"], name: "index_game_sessions_on_user_id"
  end

  create_table "media_repository", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.uuid "uploader_id"
    t.string "media_type", null: false
    t.string "url", null: false
    t.string "thumbnail_url"
    t.datetime "date_taken"
    t.jsonb "metadata", default: {}
    t.string "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_media_repository_on_event_id"
    t.index ["media_type"], name: "index_media_repository_on_media_type"
    t.index ["uploader_id"], name: "index_media_repository_on_uploader_id"
  end

  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.uuid "sender_id"
    t.string "sender_name"
    t.text "content"
    t.string "message_type", default: "text", null: false
    t.string "media_url"
    t.boolean "is_revealed", default: false, null: false
    t.datetime "reveal_date"
    t.string "status", default: "visible", null: false
    t.integer "likes_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "is_revealed"], name: "index_messages_on_event_id_and_is_revealed"
    t.index ["event_id"], name: "index_messages_on_event_id"
    t.index ["is_revealed"], name: "index_messages_on_is_revealed"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
    t.index ["status"], name: "index_messages_on_status"
  end

  create_table "rankings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.uuid "user_id", null: false
    t.integer "total_score", default: 0, null: false
    t.integer "coins", default: 0, null: false
    t.integer "streak_days", default: 0, null: false
    t.datetime "last_activity_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "total_score"], name: "index_rankings_on_event_id_and_total_score", order: { total_score: :desc }
    t.index ["event_id", "user_id"], name: "index_rankings_on_event_id_and_user_id", unique: true
    t.index ["event_id"], name: "index_rankings_on_event_id"
    t.index ["user_id"], name: "index_rankings_on_user_id"
    t.check_constraint "total_score >= 0", name: "check_score_non_negative"
  end

  create_table "shop_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.integer "cost", null: false
    t.string "item_type", null: false
    t.string "effect_name"
    t.integer "duration_seconds"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_shop_items_on_active"
    t.index ["item_type"], name: "index_shop_items_on_item_type"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "name", null: false
    t.string "role", default: "guest", null: false
    t.jsonb "profile_data", default: {}, null: false
    t.boolean "email_verified", default: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_users_on_active"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

end
