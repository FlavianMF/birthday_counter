# 🚀 Landing Page Design Specification: "Venda" da Experiência

## 1. Objetivo de Negócio
A Landing Page é a porta de entrada para novos usuários (Sponsors e Hosts). Seu objetivo é converter visitantes em criadores de eventos através de uma narrativa de antecipação e celebração digital.

## 2. Estrutura de Conteúdo (Narrativa)

### 2.1 Hero Section (O Gancho)
- **Título**: "Transforme a espera pelo aniversário na própria festa."
- **Subtítulo**: "Crie cápsulas do tempo, jogos personalizados e uma contagem regressiva interativa que explode em celebração no minuto zero."
- **CTA Principal**: [Criar Minha Celebração] (Leva ao fluxo de onboarding/registro).
- **Visual**: Mockup animado do Countdown e efeitos de partículas.

### 2.2 Social Proof & Funcionalidades (O Valor)
- **Cápsulas de Memória**: Amigos deixam mensagens e mídias que só abrem no Clímax.
- **Gamificação Social**: Geoguessr de memórias, Fact or Fiction sobre o aniversariante.
- **Economia de Coins**: Ganhe coins jogando e gaste em efeitos na festa em tempo real.

### 2.3 How it Works (O Processo)
1. **Crie o Evento**: Defina a data e o aniversariante.
2. **Convide a Galera**: Envie o link para os amigos começarem a gamificação.
3. **O Clímax**: No minuto zero, a plataforma se transforma e revela todas as surpresas.

### 2.4 FAQ & Rodapé
- Dúvidas comuns: "É grátis?", "Como funciona a integração com Spotify?", etc.

## 3. Estratégia de Conversão (UX)
- **Sticky CTA**: Botão de criação sempre visível em telas mobile.
- **Micro-Demos**: Seções interativas que simulam o Countdown ou um mini-game de Fact or Fiction.
- **FOMO (Fear Of Missing Out)**: Contador regressivo genérico para um "evento modelo" para demonstrar a animação.

## 4. Integração Técnica
- **Entrypoint**: `/` (A rota raiz será a Landing Page se o usuário não estiver logado).
- **Analytics**: Eventos de clique no CTA principal e scroll até o "How it Works".
- **SEO**: Meta tags ricas (OG Image dinâmica) para compartilhamento social.

---
**Status**: Planejado.
**Próximo Passo**: Implementação do componente `LandingPage.tsx` e redirecionamento de rotas.
