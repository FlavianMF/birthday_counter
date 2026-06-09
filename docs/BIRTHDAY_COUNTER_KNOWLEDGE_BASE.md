# 🎂 BIRTHDAY COUNTER EXPERIENCE - MASTER KNOWLEDGE BASE

Este documento consolida toda a base de conhecimento do projeto **Birthday Counter Experience**. Desenvolvido sob o **Método Karpathy (Software 3.0)**, ele serve como o *Single Source of Truth* para desenvolvimento, testes e expansão do sistema.

---

## 🗺️ Mapa de Conhecimento (MOC)

1. **Definição do Produto**: [[PRD]], [[MONETIZATION_PLAN]], [[landing_page_design]]
2. **Engenharia de Sistemas**: [[systems_engineering_foundation]], [[stakeholders]], [[user_journeys]]
3. **Modelagem Técnica**: [[db_schema]], [[api_design]], [[frontend_design]], [[FRONTEND]], [[DESIGN_SYSTEM]]
4. **Especificações Funcionais**: [[functional_spec]], [[host_invitation_flow_design]], [[EMAIL_IMPLEMENTATION]]
5. **Infraestrutura e Fixes**: [[testing_strategy]], [[FIXES_APPLIED]], [[engineering_notes]]
6. **Visual e UX**: [[DESIGN_CONCEPTS]]

---

## 1. Definição do Produto & Negócio

### 📄 Product Requirements Document (PRD)
- **Minuto Zero**: Clímax do evento com explosão de VFX e revelação de cápsulas.
- **Gamificação**:
    - **Memory Geoguessr**: Adivinhação de local de fotos com score haversine.
    - **Fact or Fiction**: Quizzes gerados por IA (LLM).
    - **Timeline Reorder**: Ordenação cronológica de mídias.
- **Economia**: Sistema de Coins e Streaks diários.
- **Viralidade**: OG Image Engine para compartilhamento dinâmico.

### 💰 Plano de Monetização
- **Modelo Híbrido**: Free (Gancho), Premium (One-time Pass), Pro (Assinatura Creator).
- **Birthday Coins**: Micro-transações para efeitos (Chuva de Emojis), Spotify Priority e Dicas.
- **B2B**: Branded Quizzes e Marketplace de Fornecedores de Festas.

---

## 2. Engenharia de Sistemas & Arquitetura

### 🏗️ Systems Engineering Foundation
- **Stack**: Ruby on Rails 7.1, Hotwire (Turbo/Stimulus), TailwindCSS, PostgreSQL, Redis, Sidekiq.
- **FSM (Máquina de Estados)**: `PRE_EVENT` -> `CLIMAX` -> `POST_EVENT` -> `ARCHIVED`.
- **Princípios**: Strict Typing (TypeScript/Pydantic), Stateless API, Idempotência.

### 👥 Stakeholders & Jornadas
- **Atores**: Host (Aniversariante), Sponsor (Organizador/Surpresa), Guest (Convidado), AI Engine, Admin.
- **Interação**: Sponsor inicia surpresa via `invitation_token`, Host ativa e cura, Guest joga e engaja.

---

## 3. Modelagem Técnica e Design

### 🗄️ Database Schema
- **Tabelas Core**: `users`, `events`, `messages`, `rankings`, `coin_transactions`.
- **JSONB**: Usado para perfis flexíveis e configurações de evento dinâmicas.
- **Extensões**: `uuid-ossp`, `pg_trgm`.

### 🔌 API Design
- **REST**: Endpoints para games, auth e mídias.
- **WebSockets**: Broadcast de `RANKING_UPDATE` e `CELEBRATION_TRIGGER`.

### 🎨 Design System & Frontend
- **Estilo**: Modern Festive Dark (Slate 950 + Violet-Fuchsia Gradients).
- **UI Patterns**: Glassmorphism, Backdrop Blur, Fluid Animations (Framer Motion).
- **Tipografia**: Montserrat (Headings), Inter (Body), JetBrains Mono (Countdown).

---

## 4. Especificações Funcionais de Engenharia

### 📋 Functional Spec
- **EventStatusCheckJob**: Verifica mudança para `CLIMAX` a cada minuto.
- **Memory Geoguessr Logic**: `score = max(0, 5000 * e^(-distancia / 1000))`.
- **Cápsulas do Tempo**: Mensagens com `is_revealed: false` até o momento zero.

### 📧 Sistema de Emails & Convites
- **Host Invitation**: Fluxo de ativação de surpresa via token.
- **NotificationMailer**: Countdown diário e convites de convidados.
- **Dev Tool**: `letter_opener` em desenvolvimento.

---

## 5. Histórico de Fixes & Infraestrutura

### 🛠️ Relatório de Correções (FIXES_APPLIED)
- **Assets**: Corrigido pipeline de Tailwind no Docker.
- **Stimulus/Esbuild**: Refatorado controllers para registro manual (removido `import.meta.glob`).
- **Sessão**: Configurado `SECRET_KEY_BASE` e `session_store` para persistência em containers.
- **Routing**: Padronizado `ProfilesController` (singular resource, plural controller).
- **Forms**: Corrigido typos de checkbox e parâmetros aninhados no registro.

### 🧪 Estratégia de Testes
- **Ambiente**: RSpec via Docker Compose.
- **Foco**: Transições de estado de FSM, integridade de transações de moedas e edge cases de datas passadas.

---

## 🎨 Conceitos Visuais (Visual Identity)
- **Atmosfera**: Antecipação crescente.
- **Mobile-First**: Navegação inferior ergonômica, touch-friendly.
- **Interatividade**: Feedback tátil e visual para cada ação gamificada.

---
**Status Final**: Base consolidada pronta para replicação e desenvolvimento agêntico.
**Data de Geração**: 29/05/2026.
**Autor**: Gemini CLI (Engineer 3.0).
