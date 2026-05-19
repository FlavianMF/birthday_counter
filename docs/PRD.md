# 📄 Product Requirements Document (PRD) V2: Detailed Specs

## 0. Aquisição e Onboarding (Funil de Vendas)

### 0.1 Landing Page
- **Objetivo**: Vender a experiência do "minuto zero" e cápsulas do tempo.
- **Métricas**: Taxa de conversão de visitantes para "Evento Criado".
- **Componentes**: Hero section, Social Proof, How it Works.

## 1. Módulo de Gamificação (Lógica de Negócio)

### 1.1 Memory Geoguessr
- **Input**: Foto com metadados GPS (Lat/Lng).
- **Processo**: O sistema oculta a localização e apresenta um mapa interativo.
- **Cálculo de Score**: 
  - `distancia = haversine(guess, actual)`
  - `score = max(0, 5000 * e^(-distancia / 1000))` (5000 pontos max, decai com a distância em km).
- **Coins**: `coins = score / 10`.

### 1.2 Fact or Fiction (AI Engine)
- **Input**: `bio_storytelling` do Host + Comentários de Amigos.
- **Processo**: LLM gera 3 afirmações: 2 reais (extraídas da bio) e 1 mentira plausível (criada pela IA).
- **Score**: Fixo 500 pontos por acerto.

### 1.3 Timeline Reorder
- **Processo**: Seleção aleatória de 3-5 fotos do `media_repository` que possuam `date_taken` no metadata.
- **Score**: 1000 pontos se 100% correto; 0 caso contrário.

## 2. Economia de Coins e Streaks
- **Daily Streak**: 
  - Dia 1: Multiplicador 1x
  - Dia 3+: Multiplicador 1.5x
  - Dia 7+: Multiplicador 2x (Max).
- **Loja de Efeitos (Spending)**:
  - Chuva de Emojis (500 coins) - Dura 10 min para todos no evento.
  - Priorizar Música (1000 coins) - Move música para o topo da fila Spotify.
  - Reveal Midia VIP (5000 coins) - Desbloqueia foto "rara".

## 3. Viral Loop & Social Sharing
- **OG Image Engine**: Serviço que renderiza um template HTML/CSS para PNG via Playwright/Puppeteer.
- **Dynamic Assets**:
  - `share/milestone/:id`: "Batemos 1000 mensagens!".
  - `share/ranking/:id`: "Estou no Top 3 da festa do [Host]!".

## 4. Módulo de Administração (Backoffice)
- **Métricas Críticas**: 
  - DAU (Daily Active Users) por Evento.
  - Taxa de Conversão Sponsor -> Host.
- **Ferramentas de Moderação**:
  - `Shadowban`: Usuário vê suas mensagens, mas ninguém mais vê.
  - `Event Freeze`: Bloqueia novas interações mas mantém visualização.

## 5. Regras de Transição (Dia Zero)
- **Trigger**: Server-side cron check a cada minuto.
- **Ação**:
  1. Alterar `status` do evento para `CLIMAX`.
  2. Emitir evento WebSocket `CELEBRATION_TRIGGER`.
  3. Atualizar flag `is_revealed` em todas as `Messages` do evento.
