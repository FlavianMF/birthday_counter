# 🗺️ User Journeys & Edge Cases (V2)

## 1. Fluxo de Recuperação e Mudança de Data
- **Cenário**: Host precisa alterar a data do aniversário.
- **Regra**: 
  - Se a nova data for **mais distante**, o sistema estende o countdown e as cápsulas permanecem bloqueadas.
  - Se a nova data for **mais próxima**, o sistema recalcula os milestones. 
  - Se a data já passou, o evento entra em `CLIMAX` imediatamente.

## 2. Fluxo de Abandono (Inactive Host)
- **Cenário**: Sponsor criou o evento, mas o Host nunca ativou.
- **Regra**: Após 7 dias da `target_date` sem ativação, o evento é auto-arquivado. O Sponsor recebe uma notificação de "Festa não realizada".

## 3. Conflito de Coin Spending
- **Cenário**: Dois usuários tentam "comprar" o topo da playlist simultaneamente.
- **Solução**: Implementação de **Redis Distributed Lock** na chave do leilão para garantir atomicidade.

## 4. Moderação em Tempo Real
- **Fluxo**:
  1. IA detecta 80% de probabilidade de conteúdo ofensivo (via OpenAI Moderation API ou similar).
  2. Mensagem é marcada como `PENDING_APPROVAL`.
  3. Admin recebe notificação via WebSocket no painel.
  4. Admin aprova ou remove.
