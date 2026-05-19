# 🗄️ Database Schema (V2 - Optimized)

## 1. Extensões Obrigatórias
```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- Para busca de nomes/mensagens
```

## 2. Índices e Performance
- `CREATE INDEX idx_events_status ON events(status);`
- `CREATE INDEX idx_rankings_event_score ON rankings(event_id, total_score DESC);`
- `CREATE INDEX idx_messages_event_revealed ON messages(event_id, is_revealed);`
- `CREATE UNIQUE INDEX idx_unique_active_event_host ON events(host_id) WHERE status = 'ACTIVE';`

## 3. Detalhamento de JSONB Schemas

### 3.1 `users.profile_data`
```json
{
  "full_name": "string",
  "avatar_url": "url",
  "preferences": {
    "notifications": "boolean",
    "theme": "dark|light"
  }
}
```

### 3.2 `events.config`
```json
{
  "theme_id": "uuid",
  "vfx_enabled": "boolean",
  "ai_complexity": "low|medium|high",
  "spotify_playlist_id": "string",
  "milestones": [
    {"type": "messages", "target": 100, "achieved": false}
  ]
}
```

## 4. Constraints de Integridade
- **Coins**: `ALTER TABLE coin_transactions ADD CONSTRAINT positive_amount CHECK (amount <> 0);`
- **Ranking**: `ALTER TABLE rankings ADD CONSTRAINT score_non_negative CHECK (total_score >= 0);`
- **Events**: `ALTER TABLE events ADD CONSTRAINT target_date_future CHECK (target_date > created_at);`
