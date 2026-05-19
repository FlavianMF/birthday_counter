# 🔌 API Design (V2 - Request/Response Payloads)

## 1. Gamificação: Play Game
`POST /events/:id/games/:type/play`

**Request Body (Geoguessr):**
```json
{
  "game_id": "uuid",
  "guess": {
    "lat": -23.5505,
    "lng": -46.6333
  },
  "client_timestamp": "ISO8601"
}
```

**Response (200 OK):**
```json
{
  "score": 4850,
  "coins_earned": 485,
  "distance_km": 0.52,
  "new_total_score": 12500,
  "rank_position": 2
}
```

## 2. Real-time: WebSocket Messages
**Event: `RANKING_UPDATE`**
```json
{
  "event_type": "RANKING_UPDATE",
  "payload": {
    "top_3": [
      {"user_id": "uuid", "name": "Alice", "score": 15000},
      {"user_id": "uuid", "name": "Bob", "score": 14500},
      {"user_id": "uuid", "name": "You", "score": 12500}
    ]
  }
}
```

## 3. Social: Capsule Message
`POST /events/:id/messages`

**Multipart Form Data:**
- `type`: "VIDEO"
- `file`: Binary Data (mp4)
- `sender_name`: "Opcional se logado"

**Response (201 Created):**
```json
{
  "id": "uuid",
  "status": "LOCKED",
  "reveal_date": "2026-05-12T00:00:00Z"
}
```

## 4. Auth: Login
`POST /auth/login`

**Response:**
```json
{
  "access_token": "jwt_string",
  "refresh_token": "jwt_string",
  "user": {
    "id": "uuid",
    "role": "HOST|GUEST|ADMIN",
    "name": "string"
  }
}
```
