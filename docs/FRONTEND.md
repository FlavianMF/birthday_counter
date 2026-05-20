# Birthday Counter Experience - Frontend Documentation

## Visão Geral do Frontend

O frontend do **Birthday Counter Experience** foi desenvolvido com **Ruby on Rails 7.1 + Hotwire** para uma experiência moderna, rápida e mobile-first, com design aprimorado usando **Tailwind CSS** e animações fluidas.

### Stack Tecnológico

- **Framework**: Ruby on Rails 7.1
- **Frontend Stack**: Hotwire (Turbo + Stimulus)
- **Estilização**: TailwindCSS 3.0+
- **JavaScript**: Importmap (sem build step)
- **Ícones**: Heroicons
- **Fontes**: Inter, Montserrat, JetBrains Mono
- **Animações**: Stimulus controllers + Tailwind animations

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

/* Additional Colors */
Success: #10B981 (Emerald 500)
Info: #3B82F6 (Blue 500)
Cyan: #06B6D4
```

### Componentes Principais

1. **Glass Card** - Cartões com efeito glassmorphism e backdrop-blur
2. **Buttons** - Primários com gradiente e glow, Secundários minimalistas
3. **Inputs** - Estilo glass com focus ring e ícones
4. **Badges** - Tags para status e labels com cores semânticas
5. **Countdown Digits** - Números com fonte mono e gradiente
6. **Stat Cards** - Cards de estatísticas com animações
7. **Navigation** - Bottom nav mobile, top nav desktop

### Animações e Efeitos

- **fade-in**: Fade in simples
- **slide-up/down**: Slide vertical
- **slide-right**: Slide horizontal
- **scale-in**: Scale up com fade
- **float**: Float suave (keyframes)
- **pulse-glow**: Glow pulsante
- **blob**: Animação orgânica de fundo
- **gradient**: Gradiente animado
- **bounce-soft**: Bounce suave

### Mobile-First Approach

- Bottom navigation para mobile
- Top navigation para desktop
- Touch-friendly (mínimo 44px de altura)
- Safe area insets para dispositivos modernos
- Responsive breakpoints: sm (640px), md (768px), lg (1024px)

## Estrutura de Views

### Layouts
- `application.html.erb` - Layout principal com background animado
- Componentes compartilhados:
  - `_navbar.html.erb` - Navegação desktop
  - `_bottom_nav.html.erb` - Navegação mobile
  - `_flash_messages.html.erb` - Notificações toast

### Páginas Principais

1. **Home** (`pages/home.html.erb`)
   - Hero section com logo animado
   - Countdown em tempo real
   - Features grid com cards interativos
   - Stats section

2. **Autenticação**
   - `sessions/new.html.erb` - Login com design glassmorphism
   - `registrations/new.html.erb` - Registro com validações

3. **Eventos**
   - `events/index.html.erb` - Lista de eventos com grid
   - `events/show.html.erb` - Detalhes do evento com countdown
   - `events/new.html.erb` - Formulário de criação
   - `events/edit.html.erb` - Edição de evento

4. **Jogos**
   - `games/index.html.erb` - Grid de jogos com stats
   - `games/geoguessr.html.erb` - Geoguessr
   - `games/fact_or_fiction.html.erb` - Fact or Fiction
   - `games/timeline.html.erb` - Timeline Reorder

5. **Ranking**
   - `rankings/index.html.erb` - Podium e leaderboard

6. **Perfil**
   - `profile/show.html.erb` - Stats do usuário e conquistas

## Stimulus Controllers

### Countdown Controller

```javascript
// app/javascript/controllers/countdown_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["days", "hours", "minutes", "seconds"]
  static values = { date: String }

  connect() {
    this.update()
    this.interval = setInterval(() => this.update(), 1000)
  }

  disconnect() {
    if (this.interval) {
      clearInterval(this.interval)
    }
  }

  update() {
    const target = new Date(this.dateValue).getTime()
    const now = new Date().getTime()
    const diff = target - now

    if (diff > 0) {
      const days = Math.floor(diff / (1000 * 60 * 60 * 24))
      const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
      const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))
      const seconds = Math.floor((diff % (1000 * 60)) / 1000)

      this.animateValue(this.daysTarget, this.pad(days))
      this.animateValue(this.hoursTarget, this.pad(hours))
      this.animateValue(this.minutesTarget, this.pad(minutes))
      this.animateValue(this.secondsTarget, this.pad(seconds))
    }
  }

  animateValue(element, newValue) {
    element.classList.add('scale-110', 'text-fuchsia-400')
    setTimeout(() => {
      element.textContent = newValue
      element.classList.remove('scale-110', 'text-fuchsia-400')
    }, 150)
  }

  pad(num) {
    return num.toString().padStart(2, '0')
  }
}
```

### Intersection Observer Controller

```javascript
// app/javascript/controllers/intersection_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    threshold: { type: Number, default: 0.1 },
    rootMargin: { type: String, default: '0px' },
    animation: { type: String, default: 'fade-in' }
  }

  connect() {
    this.observer = new IntersectionObserver(this.handleIntersect.bind(this), {
      threshold: this.thresholdValue,
      rootMargin: this.rootMarginValue
    })
    this.observer.observe(this.element)
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  handleIntersect(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add(`animate-${this.animationValue}`)
        if (this.data.once !== 'false') {
          this.observer.unobserve(entry.target)
        }
      }
    })
  }
}
```

### Modal Controller

```javascript
// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "content"]
  static values = { isOpen: Boolean }

  open() {
    this.element.classList.remove('hidden')
    this.element.classList.add('flex')
    this.overlayTarget.classList.remove('opacity-0')
    this.overlayTarget.classList.add('opacity-100')
    this.contentTarget.classList.remove('scale-95', 'opacity-0')
    this.contentTarget.classList.add('scale-100', 'opacity-100')
    document.body.style.overflow = 'hidden'
  }

  close() {
    this.overlayTarget.classList.remove('opacity-100')
    this.overlayTarget.classList.add('opacity-0')
    this.contentTarget.classList.remove('scale-100', 'opacity-100')
    this.contentTarget.classList.add('scale-95', 'opacity-0')
    setTimeout(() => {
      this.element.classList.add('hidden')
      this.element.classList.remove('flex')
    }, 200)
    document.body.style.overflow = ''
  }
}
```

### Tabs Controller

```javascript
// app/javascript/controllers/tabs_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static values = { active: String }

  select(id) {
    this.activeValue = id
    this.tabTargets.forEach(tab => {
      const isActive = tab.dataset.id === id
      tab.classList.toggle('text-primary', isActive)
      tab.classList.toggle('border-b-2', isActive)
    })
    this.panelTargets.forEach(panel => {
      panel.classList.toggle('hidden', panel.dataset.id !== id)
    })
  }
}
```

## Tailwind Customization

O arquivo `tailwind.config.js` inclui:

- Cores personalizadas do tema
- Fontes customizadas (Google Fonts)
- Animações customizadas (fade-in, slide-up, pulse-glow, blob, gradient)
- Componentes via @layer
- Extended spacing e borderRadius

## Configuração de Ambiente

### Desenvolvimento

```bash
# Instalar dependências
bundle install
npm install

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

## Boas Práticas

1. **Mobile-First**: Comece pelo mobile, adicione breakpoints para telas maiores
2. **Progressive Enhancement**: Funciona sem JavaScript, melhora com JS
3. **Accessibility**: Use tags semânticas, ARIA labels, contraste adequado
4. **Performance**: Lazy loading, image optimization, code splitting
5. **Consistency**: Use os componentes do design system
6. **Animations**: Use animações com moderação, prefira CSS transitions
7. **Stagger**: Use animation-delay para efeitos em cascata

## Componentes Disponíveis

### Buttons
- `.btn-primary` - Botão primário com gradiente
- `.btn-secondary` - Botão secundário minimalista
- `.btn-danger` - Botão de perigo (vermelho)
- `.btn-success` - Botão de sucesso (verde)

### Cards
- `.glass-card` - Card com glassmorphism
- `.game-card` - Card de jogo com hover effects
- `.feature-card` - Card de feature
- `.stat-card` - Card de estatísticas

### Inputs
- `.input-glass` - Input com estilo glass
- `.input-glass-icon` - Input com ícone

### Utilities
- `.text-gradient` - Texto com gradiente
- `.text-gradient-gold` - Texto com gradiente dourado
- `.animate-float` - Animação de float
- `.safe-bottom` - Padding para safe area

## Próximos Passos

- [ ] Implementar todos os Stimulus controllers
- [ ] Criar views de jogos (Geoguessr, Fact or Fiction, Timeline)
- [ ] Adicionar PWA manifest para instalação mobile
- [ ] Implementar offline mode com Service Workers
- [ ] Adicionar dark mode toggle
- [ ] Implementar skeleton loaders
- [ ] Adicionar more micro-interactions

## Referências

- [Hotwire Documentation](https://hotwired.dev/)
- [TailwindCSS Documentation](https://tailwindcss.com/docs)
- [Stimulus Handbook](https://stimulus.hotwired.dev/handbook)
- [Rails Guides](https://guides.rubyonrails.org/)
- [Tailwind UI](https://tailwindui.com/)
- [Headless UI](https://headlessui.com/)
