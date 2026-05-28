# 📋 Especificação Funcional e Diretrizes de Desenvolvimento

Este documento detalha as funcionalidades do **Birthday Counter Experience** para guiar os agentes de Desenvolvimento e Testes.

## 1. Ciclo de Vida do Evento (FSM)
O sistema deve gerenciar rigorosamente os estados do evento baseados no `target_date`.

### 1.1 Estados
- **ACTIVE**: Antes do `target_date`. Gamificação liberada, mensagens ocultas (is_revealed: false).
- **CLIMAX**: No momento exato do `target_date`. Dispara animações (VFX), revela mensagens, encerra gamificação.
- **POST_EVENT**: 24h após o Clímax. Modo de visualização/memória.
- **ARCHIVED**: 30 dias após ou manual. Somente leitura histórica.

### 1.2 Transições Críticas
- **Trigger**: `EventStatusCheckJob` (Sidekiq) executado a cada minuto.
- **Ação Clímax**: Alterar `status` para `climax`, setar `is_revealed: true` em todas as mensagens do evento, disparar broadcast via ActionCable.

---

## 2. Motor de Gamificação (Games)
Lógica de pontos e recompensas para engajamento pré-evento.

### 2.1 Memory Geoguessr
- **Fórmula de Score**: `5000 * e^(-distancia_km / 1000)`.
- **Regra**: Distância calculada via fórmula de Haversine entre o palpite e a localização real da foto (`media_repository`).
- **Output**: Coins ganhos = `score / 10`.

### 2.2 Fact or Fiction
- **Lógica**: Usuário escolhe entre afirmações sobre o aniversariante.
- **Score**: Fixo 500 pontos por acerto.

### 2.3 Timeline Reorder
- **Lógica**: Ordenar fotos cronologicamente.
- **Score**: 1000 pontos se 100% correto.

---

## 3. Economia de Coins e Loja
Sistema de recompensas e gastos.

### 3.1 Ganhos (Earn)
- Via Jogos (Geoguessr, etc).
- Via Streaks: Multiplicador 1.5x (3 dias), 2x (7 dias).

### 3.2 Gastos (Spend)
- **Efeitos Visuais**: "Chuva de Emojis" (500 coins). Cria um `ActiveEffect`.
- **Reveal VIP**: Desbloqueia mídias raras.
- **Transação**: Deve ser atômica. Verificar saldo antes de debitar.

---

## 4. Sistema de Mensagens (Cápsula do Tempo)
Core da experiência de surpresa.

### 4.1 Envio e Visibilidade
- **Shadowban**: Mensagem visível apenas para o remetente (moderação).
- **Reveal logic**: Mensagens com `is_revealed: false` só podem ser lidas pelo autor ou admins antes do clímax.
- **Tipos**: Texto, Imagem (via `media_url`).

---

## 5. Notificações e Emails
Engajamento recorrente e aquisição de usuários.

### 5.1 Countdown Diário
- **Lógica**: Notificação diária para participantes de eventos ativos.
- **Job**: `DailyCountdownJob` (execução agendada).
- **Conteúdo**: Dias restantes e link direto para o evento.

### 5.2 Convites e Surpresas
- **Convite de Host (Surpresa)**: Disparado quando um evento surpresa é criado com `recipient_email`. Contém o `invitation_token` para reivindicação.
- **Convite de Convidado**: Disparado manualmente para convidar novos usuários a participar de um evento existente.

---

## 💡 Diretrizes para Agentes

### Para o Agente de Desenvolvimento (Coder)
- **DRY**: Use `BroadcastService` para todas as comunicações via WebSocket.
- **Segurança**: Garanta que o `access_code` é necessário para participar de eventos privados.
- **Mobile First**: Utilize as classes utilitárias do Tailwind conforme definido em `DESIGN_SYSTEM.md`.
- **API**: Mantenha compatibilidade com o schema JSON definido em `docs/api_design.md`.

### Para o Agente de Testes (Tester)
- **Unitários (Models)**: Testar transições de estado no `Event` e cálculos de score no `Ranking`.
- **Integração (Requests)**: Validar que usuários sem saldo não podem comprar itens na loja.
- **Edge Cases**: 
  - O que acontece se o `target_date` for no passado?
  - Testar concorrência em transações de Coins.
  - Validar que mensagens `shadowbanned` realmente não aparecem para outros participantes.
