# 🎨 Frontend Design Specification: Birthday Counter Experience

## 1. Visão Geral do Design (Aesthetics)
O design deve evocar um sentimento de **antecipação, celebração e interatividade**. Abandonamos o visual estático em favor de uma interface "viva" que reage às ações do usuário e à proximidade do evento.

### 1.1 Estilo Visual: Modern Festive Dark
- **Base**: Dark Mode por padrão para destacar cores vibrantes e efeitos de partículas.
- **Glassmorphism**: Uso intensivo de cartões translúcidos com `backdrop-filter: blur()` para criar profundidade.
- **Micro-interações**: Feedback tátil e visual em cada clique (Framer Motion).

## 2. Design System

### 2.1 Cores (Palette)
- **Background**: `#0F172A` (Slate 950)
- **Primary (Celebration)**: `#8B5CF6` (Violet 500) -> `#D946EF` (Fuchsia 500) gradient.
- **Secondary (Coins/Success)**: `#F59E0B` (Amber 500)
- **Accent (Urgency)**: `#EF4444` (Red 500)
- **Surface**: `rgba(30, 41, 59, 0.7)` (Slate 800 com transparência)

### 2.2 Tipografia
- **Headings**: `Montserrat` ou `Inter` (Extra Bold) para títulos impactantes.
- **Digits (Countdown)**: `JetBrains Mono` ou `Space Mono` (Monospaced) para evitar "pulos" durante a contagem.
- **Body**: `Inter` (Medium/Regular) para legibilidade.

### 2.3 Componentes (Base: Tailwind + Radix/Shadcn)
- **Cards**: Bordas sutis (`border-white/10`) e sombras suaves.
- **Buttons**: Gradientes vibrantes com efeito de "glow" no hover.
- **Progress Bars**: Estilo "Liquid" (fluído) para indicar progresso de coins ou streaks.

## 3. Layout Responsivo (Mobile-First)

### 3.1 Mobile (< 768px)
- **Header**: Countdown fixo no topo com tipografia grande.
- **Main Content**: Scroll vertical de cartões de gamificação (um por linha).
- **Navigation**: Bottom Tab Bar para acesso rápido: [Home, Games, Shop, Ranking].

### 3.2 Desktop (>= 768px)
- **Header**: Sidebar ou Top Nav elegante.
- **Main Content**: Grid de 2 ou 3 colunas.
- **Real-time Feed**: Sidebar lateral com as últimas mensagens e atividades.

## 4. Design por Papel (Role-Based UI)

### 4.1 Admin/Host Dashboard
- **Visão de Moderação**: Lista de mensagens `PENDING_APPROVAL` com ações rápidas de Aprovar/Remover.
- **Métricas**: Gráficos simples de DAU e engajamento.
- **Controles**: Botão de "Event Freeze" em destaque.

### 4.2 Guest (Participante)
- **Status de Moedas**: Badge flutuante persistente mostrando o saldo atual.
- **Ranking Real-time**: Widget compacto que desliza do topo ou lateral em atualizações de WebSocket.

## 5. Design de Jogos (Gamification UI)

### 5.1 Memory Geoguessr
- **UI**: Mapa interativo ocupando 70% da viewport.
- **Overlay**: Painel flutuante com a foto a ser adivinhada.
- **Feedback**: Animação de linha conectando o "chute" ao local real com score flutuante.

### 5.2 Fact or Fiction
- **UI**: Cartões estilo "Tinder" ou botões grandes de alta fidelidade.
- **VFX**: Explosão de confetti verde no acerto, tremor vermelho no erro.

### 5.3 Timeline Reorder
- **UI**: Lista horizontal de miniaturas de fotos com ícones de "drag" visíveis.
- **UX**: Feedback de animação suave ao reordenar (Reorder.Group do Framer Motion).

## 6. Estados Visuais (System States)

| Estado | UI / Atmosfera |
| :--- | :--- |
| **PRE_EVENT** | Foco no Countdown. Cores roxas/azuis. Gamificação em destaque. |
| **CLIMAX (00:00)** | Explosão de VFX. Cores Gold/Fuchsia. Reveal central da cápsula do tempo. |
| **POST_EVENT** | Layout de galeria/museu. Tons mais sóbrios e nostálgicos. |

## 7. Referências e Inspirações
- **App Forest**: Pelo loop de crescimento visual (Gamificação).
- **Airbnb Maps**: Pela fluidez da interface de mapa.
- **Duolingo**: Pelo uso de streaks e feedback de acerto/erro.

---
**Status Atual**: Design System e Protótipo Base Implementados.
**Implementação Técnica**:
- **Stack**: React 18, Vite, Tailwind CSS, Framer Motion, React Leaflet.
- **Roteamento**: `react-router-dom` para navegação entre Home e Jogos.
- **Interatividade**: `framer-motion` para transições de página e feedback visual de jogos.
---
**Instrução para Implementação**: Utilize `framer-motion` para todas as transições de página e estados de hover para garantir o "feeling" premium da aplicação.
