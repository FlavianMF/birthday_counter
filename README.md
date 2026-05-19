# 🎂 Birthday Counter Experience - Ruby on Rails API

Uma plataforma completa para criação de eventos de aniversário interativos com gamificação, cápsulas do tempo e contagem regressiva em tempo real.

## 📋 Visão Geral

O **Birthday Counter Experience** é uma sistema que transforma a espera pelo aniversário em uma experiência gamificada e social. Os usuários podem criar eventos, enviar mensagens em cápsulas do tempo, competir em rankings através de jogos e celebrar juntos no "minuto zero".

## 🏗️ Arquitetura

### Stack Tecnológico

- **Backend**: Ruby on Rails 7.1 API + Full Stack
- **Frontend**: Hotwire (Turbo + Stimulus) + TailwindCSS
- **Banco de Dados**: PostgreSQL 15+ com extensões (uuid-ossp, pg_trgm)
- **Cache/Real-time**: Redis 7+
- **Autenticação**: Session-based + JWT (API)
- **Background Jobs**: Sidekiq
- **WebSockets**: ActionCable

### Estrutura do Projeto

```
birthday_project/
├── app/
│   ├── controllers/api/v1/    # Controladores da API
│   ├── models/                # Modelos ActiveRecord
│   ├── channels/              # Canais WebSocket (ActionCable)
│   ├── jobs/                  # Background jobs
│   └── services/              # Serviços de negócio
├── db/
│   └── migrate/               # Migrações do banco
├── config/
│   ├── routes.rb              # Rotas da API
│   └── database.yml           # Configuração do banco
├── docker-compose.yml         # Orquestração Docker
└── Dockerfile                 # Containerização
```

## 🚀 Funcionalidades

### 1. Gamificação

#### Memory Geoguessr
- **Descrição**: Jogo onde usuários adivinham localização de fotos com base em coordenadas GPS
- **Pontuação**: `score = 5000 * e^(-distancia / 1000)` (máx 5000 pontos)
- **Recompensa**: 10% do score em coins

#### Fact or Fiction
- **Descrição**: IA gera 3 afirmações sobre o aniversariante (2 reais, 1 mentira)
- **Pontuação**: 500 pontos fixos por acerto
- **Recompensa**: 50 coins por acerto

#### Timeline Reorder
- **Descrição**: Ordenar fotos cronologicamente
- **Pontuação**: 1000 pontos se 100% correto
- **Recompensa**: 100 coins

### 2. Economia de Coins

| Ação | Coins |
|------|-------|
| Geoguessr (score 5000) | 500 |
| Fact or Fiction (acerto) | 50 |
| Timeline (perfeito) | 100 |
| Chuva de Emojis (custo) | -500 |
| Priorizar Música (custo) | -1000 |
| Reveal Media VIP (custo) | -5000 |

**Streak Multipliers**:
- Dia 1: 1x
- Dia 3+: 1.5x
- Dia 7+: 2x (máximo)

### 3. Estados do Evento (FSM)

```
[*] --> PRE_EVENT: Event Created
PRE_EVENT --> CLIMAX: target_date reached (00:00)
CLIMAX --> POST_EVENT: 24h after target_date
POST_EVENT --> ARCHIVED: Manually or 30 days after
```

### 4. Real-time Features (WebSocket)

- `EVENT_STATUS_CHANGE`: Transição de estados
- `NEW_MESSAGE`: Nova mensagem no mural
- `RANKING_UPDATE`: Atualização do ranking
- `CELEBRATION_TRIGGER`: Início da celebração

## 🛠️ Instalação e Configuração

### Pré-requisitos

**Mínimos:**
- Docker e Docker Compose (recomendado)

**OU (para desenvolvimento local):**

- Ruby 3.0.2
- PostgreSQL 15+
- Redis 7+
- Node.js e npm

### 1. Docker Compose (Recomendado - Mais Rápido)

```bash
# Clonar repositório
cd /workspace/birthday_project

# Copiar arquivo de ambiente
cp .env.docker .env

# Iniciar todos os serviços (API, Database, Redis, Sidekiq)
docker-compose up -d

# Verificar status
docker-compose ps

# Acessar logs
docker-compose logs -f api

# Parar serviços
docker-compose down
```

**Vantagens do Docker:**
- ✅ Ambiente isolado e consistente
- ✅ Todas as dependências incluídas
- ✅ Banco de dados e Redis pré-configurados
- ✅ Fácil de implantar em produção

### 2. Instalação Local (Desenvolvimento)

```bash
# Clonar repositório
cd /workspace/birthday_project

# Instalar dependências Ruby
bundle install

# Criar banco de dados
sudo -u postgres psql -c "CREATE DATABASE birthday_counter_development;"
sudo -u postgres psql -c "CREATE DATABASE birthday_counter_test;"

# Configurar variáveis de ambiente
export DATABASE_USERNAME=postgres
export DATABASE_PASSWORD=postgres
export REDIS_URL=redis://localhost:6379/0

# Rodar migrações
bundle exec rake db:migrate

# Iniciar Redis (em segundo plano)
redis-server &

# Iniciar servidor Rails
bundle exec rails server
```

### 3. Variáveis de Ambiente

Copie `.env.example` para `.env` e ajuste:

```bash
cp .env.example .env
```

Principais variáveis:
- `DATABASE_USERNAME`: Usuário do PostgreSQL
- `DATABASE_PASSWORD`: Senha do PostgreSQL
- `REDIS_URL`: URL do Redis
- `JWT_SECRET`: Segredo para JWT
- `AWS_*`: Configurações S3 (opcional)
- `SPOTIFY_*`: Integração Spotify (opcional)
- `OPENAI_API_KEY`: Para Fact or Fiction game (opcional)

## 📡 API Endpoints

### Autenticação

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | `/api/v1/auth/register` | Registrar novo usuário |
| POST | `/api/v1/auth/login` | Login |
| POST | `/api/v1/auth/refresh` | Refresh token |
| GET | `/api/v1/auth/me` | Dados do usuário atual |

### Eventos

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/v1/events` | Listar eventos |
| GET | `/api/v1/events/:id` | Detalhes do evento |
| POST | `/api/v1/events` | Criar evento |
| PUT | `/api/v1/events/:id` | Atualizar evento |
| DELETE | `/api/v1/events/:id` | Deletar evento |
| POST | `/api/v1/events/:id/join` | Entrar no evento |
| GET | `/api/v1/events/:id/messages` | Listar mensagens |
| POST | `/api/v1/events/:id/messages` | Enviar mensagem |
| GET | `/api/v1/events/:id/ranking` | Ranking do evento |

### Jogos

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | `/api/v1/events/:event_id/games/geoguessr/play` | Jogar Geoguessr |
| POST | `/api/v1/events/:event_id/games/fact-or-fiction/play` | Jogar Fact or Fiction |
| POST | `/api/v1/events/:event_id/games/timeline-reorder/play` | Jogar Timeline Reorder |

## 🎮 Exemplos de Uso

### Criar Evento

```bash
curl -X POST http://localhost:3000/api/v1/events \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "event": {
      "name": "Aniversário do João",
      "description": "Festa surpresa!",
      "target_date": "2026-12-31T23:59:59Z",
      "is_surprise": true
    }
  }'
```

### Enviar Mensagem

```bash
curl -X POST http://localhost:3000/api/v1/events/EVENT_ID/messages \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "content": "Parabéns! 🎉",
    "message_type": "text"
  }'
```

### Jogar Geoguessr

```bash
curl -X POST http://localhost:3000/api/v1/events/EVENT_ID/games/geoguessr/play \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "guess": {
      "lat": -23.5505,
      "lng": -46.6333
    },
    "actual_lat": -23.5500,
    "actual_lng": -46.6300
  }'
```

## 🗄️ Modelo de Dados

### Principais Tabelas

- **users**: Usuários do sistema
- **events**: Eventos de aniversário
- **event_participants**: Participantes por evento
- **messages**: Mensagens/cápsulas do tempo
- **rankings**: Pontuação e coins por usuário/evento
- **coin_transactions**: Histórico de transações
- **game_sessions**: Sessões de jogos
- **media_repository**: Mídias (fotos, vídeos)
- **shop_items**: Itens da loja
- **active_effects**: Efeitos ativados
- **audit_logs**: Logs de auditoria (admin)

## 🔐 Segurança

- Autenticação via JWT com expiração
- Senhas criptografadas com bcrypt
- CORS configurado para domínios específicos
- Validação de papel (RBAC): host, guest, sponsor, admin
- Shadowban para moderação

## 📊 Background Jobs

Jobs assíncronos com Sidekiq:

- `EventStatusCheckJob`: Verifica transições de estado dos eventos
- Broadcast de atualizações em tempo real
- Processamento de mídias

## 🧪 Testes

```bash
# Rodar testes
bundle exec rspec

# Testes de models
bundle exec rspec spec/models

# Testes de controllers
bundle exec rspec spec/controllers
```

## 🚀 Deploy

### Docker Production

```bash
# Build para produção
docker-compose -f docker-compose.yml build

# Deploy
docker-compose -f docker-compose.yml up -d
```

### Variáveis de Produção

- Use `DATABASE_URL` para conexão PostgreSQL
- Configure `REDIS_URL` para Redis externo
- Defina `RAILS_MASTER_KEY` para segredos
- Use segredos reais para `JWT_SECRET`

## 📝 Próximos Passos

- [ ] Implementar upload de arquivos (Active Storage + S3)
- [ ] Painel admin backoffice
- [ ] Integração com Spotify API
- [ ] Moderação com IA (OpenAI)
- [ ] Landing page de conversão
- [ ] Frontend React/Vue.js

## 📄 Licença

MIT License

## 👥 Stakeholders

- **Host**: Aniversariante, dono do evento
- **Sponsor**: Criador do evento (surpresa)
- **Guest**: Amigos participantes
- **Admin**: Moderação e governança

---

**Status**: Em desenvolvimento
**Versão**: 1.0.0
**Última atualização**: Maio 2026
