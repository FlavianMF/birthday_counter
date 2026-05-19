# Birthday Counter Experience - Frontend Documentation

## Visão Geral do Frontend

O frontend do **Birthday Counter Experience** foi desenvolvido com **Ruby on Rails 7.1 + Hotwire** para uma experiência moderna, rápida e mobile-first.

### Stack Tecnológico

- **Framework**: Ruby on Rails 7.1
- **Frontend Stack**: Hotwire (Turbo + Stimulus)
- **Estilização**: TailwindCSS 2.0
- **JavaScript**: Importmap (sem build step)
- **Ícones**: Heroicons
- **Fontes**: Inter, Montserrat, JetBrains Mono

## Design System

### Cores (Modern Festive Dark)

```css
/* Background & Surface */
Background: #0F172A (Slate 950)
Surface: rgba(30, 41, 59, 0.7) (Slate 800 com transparência)

/* Primary (Celebration) */
Primary: #8B5CF6 (Violet 500) → #D946EF (Fuchsia 500) gradient

/* Secondary (Coins/Success) */
Secondary: #F59E0B (Amber 500)

/* Accent (Urgency) */
Accent: #EF4444 (Red 500)
```

### Componentes Principais

1. **Glass Card** - Cartões com efeito glassmorphism
2. **Buttons** - Primários com gradiente e glow, Secundários minimalistas
3. **Inputs** - Estilo glass com focus ring
4. **Badges** - Tags para status e labels
5. **Countdown Digits** - Números com fonte mono e gradiente

### Mobile-First Approach

- Bottom navigation para mobile
- Top navigation para desktop
- Touch-friendly (mínimo 44px de altura)
- Safe area insets para dispositivos modernos
- Responsive breakpoints: sm (640px), md (768px), lg (1024px)

## Estrutura de Views

### Layouts
- `application.html.erb` - Layout principal
- Componentes compartilhados:
  - `_navbar.html.erb` - Navegação desktop
  - `_bottom_nav.html.erb` - Navegação mobile
  - `_flash_messages.html.erb` - Notificações

### Páginas Principais

1. **Home** (`pages/home.html.erb`)
   - Countdown em tempo real
   - Features grid
   - CTAs para login/registro

2. **Autenticação**
   - `sessions/new.html.erb` - Login
   - `registrations/new.html.erb` - Registro

3. **Eventos**
   - `events/index.html.erb` - Lista de eventos
   - `events/show.html.erb` - Detalhes do evento
   - `events/new.html.erb` - Criar evento
   - `events/edit.html.erb` - Editar evento

4. **Jogos**
   - `games/index.html.erb` - Lista de jogos
   - `games/geoguessr.html.erb` - Geoguessr
   - `games/fact_or_fiction.html.erb` - Fact or Fiction
   - `games/timeline.html.erb` - Timeline Reorder

5. **Ranking**
   - `rankings/index.html.erb` - Classificação

## Stimulus Controllers

### Exemplo: Countdown Controller

```javascript
// app/javascript/controllers/countdown_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["days", "hours", "minutes", "seconds"]
  
  connect() {
    this.update()
    setInterval(() => this.update(), 1000)
  }
  
  update() {
    const target = new Date(this.dateValue).getTime()
    const now = new Date().getTime()
    const diff = target - now
    
    if (diff > 0) {
      this.daysTarget.textContent = this.pad(Math.floor(diff / (1000 * 60 * 60 * 24)))
      this.hoursTarget.textContent = this.pad(Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)))
      this.minutesTarget.textContent = this.pad(Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60)))
      this.secondsTarget.textContent = this.pad(Math.floor((diff % (1000 * 60)) / 1000))
    }
  }
  
  pad(num) {
    return num.toString().padStart(2, '0')
  }
}
```

## WebSocket Integration

### Turbo Streams para Real-time

```erb
<!-- Notificações em tempo real -->
<%= turbo_stream_from "notifications", current_user %>

<!-- Atualização de ranking -->
<%= turbo_stream_from "events/#{@event.id}/ranking" %>
```

### ActionCable Channel

```ruby
# app/channels/ranking_channel.rb
class RankingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "ranking:#{params[:event_id]}"
  end
end
```

## Configuração de Ambiente

### Desenvolvimento

```bash
# Instalar dependências
bundle install

# Rodar migrações
rails db:migrate

# Iniciar servidor
rails server

# Ou com Docker
docker compose up
```

### Produção

```bash
# Build de assets
rails assets:precompile

# Rodar migrações
rails db:migrate

# Iniciar servidor Puma
rails server -e production
```

## Tailwind Customization

O arquivo `tailwind.config.js` inclui:

- Cores personalizadas do tema
- Fontes customizadas (Google Fonts)
- Animações (fade-in, slide-up, pulse-glow)
- Componentes via @layer

## Boas Práticas

1. **Mobile-First**: Comece pelo mobile, adicione breakpoints para telas maiores
2. **Progressive Enhancement**: Funciona sem JavaScript, melhora com JS
3. **Accessibility**: Use tags semânticas, ARIA labels, contraste adequado
4. **Performance**: Lazy loading, image optimization, code splitting
5. **Consistency**: Use os componentes do design system

## Próximos Passos

- [ ] Implementar todos os Stimulus controllers
- [ ] Criar views de jogos (Geoguessr, Fact or Fiction, Timeline)
- [ ] Adicionar animações com Framer Motion (via React se necessário)
- [ ] Otimizar performance (lazy loading, code splitting)
- [ ] Adicionar PWA manifest para instalação mobile
- [ ] Implementar offline mode com Service Workers

## Referências

- [Hotwire Documentation](https://hotwired.dev/)
- [TailwindCSS Documentation](https://tailwindcss.com/docs)
- [Stimulus Handbook](https://stimulus.hotwired.dev/handbook)
- [Rails Guides](https://guides.rubyonrails.org/)
