# Design System - Birthday Counter

## Visão Geral

Este documento descreve o design system do Birthday Counter Experience, incluindo cores, tipografia, componentes, e padrões de uso.

## Princípios de Design

1. **Modern Festive**: Celebração com elegância, não exagero
2. **Mobile-First**: Otimizado para dispositivos móveis
3. **Accessible**: Acessível para todos os usuários
4. **Performant**: Rápido e responsivo
5. **Consistent**: Padrões consistentes em toda a aplicação

## Cores

### Palette Principal

```
Background:     #0F172A  (Slate 950)
Surface:        rgba(30, 41, 59, 0.7)  (Slate 800 com transparência)

Primary:        #8B5CF6  (Violet 500)
Primary Hover:  #7C3AED  (Violet 600)
Primary Glow:   rgba(139, 92, 246, 0.5)

Fuchsia:        #D946EF  (Fuchsia 500)
Fuchsia Glow:   rgba(217, 70, 239, 0.5)

Secondary:      #F59E0B  (Amber 500)
Secondary Hover: #D97706 (Amber 600)

Accent:         #EF4444  (Red 500)
Success:        #10B981  (Emerald 500)
Info:           #3B82F6  (Blue 500)
Cyan:           #06B6D4  (Cyan 500)
```

### Cores Semânticas

```css
/* Status */
Success: #10B981
Warning: #F59E0B
Error: #EF4444
Info: #3B82F6

/* States */
Active: #8B5CF6
Inactive: rgba(255, 255, 255, 0.5)
Disabled: rgba(255, 255, 255, 0.2)
```

## Tipografia

### Fontes

```css
/* Heading */
font-family: 'Montserrat', system-ui, sans-serif;
font-weight: 700-800;

/* Body */
font-family: 'Inter', system-ui, sans-serif;
font-weight: 400-600;

/* Mono (Countdown, numbers) */
font-family: 'JetBrains Mono', monospace;
font-weight: 400-500;
```

### Escala Tipográfica

```
h1: 2.5rem (40px) - Mobile, 3rem (48px) - Desktop
h2: 2rem (32px) - Mobile, 2.25rem (36px) - Desktop
h3: 1.5rem (24px) - Mobile, 1.75rem (28px) - Desktop
h4: 1.25rem (20px)
Body: 1rem (16px)
Small: 0.875rem (14px)
XSmall: 0.75rem (12px)
```

## Componentes

### Buttons

#### Primary Button

```html
<button class="btn-primary">
  Click me
</button>
```

- Background: Gradient (Violet to Fuchsia)
- Text: White
- Border Radius: 0.75rem (xl)
- Padding: 0.75rem 1.5rem
- Hover: Scale 1.05, Shadow glow
- Active: Scale 0.98

#### Secondary Button

```html
<button class="btn-secondary">
  Click me
</button>
```

- Background: rgba(255, 255, 255, 0.1)
- Text: White
- Border: 1px solid rgba(255, 255, 255, 0.2)
- Border Radius: 0.75rem (xl)
- Padding: 0.75rem 1.5rem
- Hover: Background rgba(255, 255, 255, 0.2)

### Cards

#### Glass Card

```html
<div class="glass-card">
  Content here
</div>
```

- Background: rgba(30, 41, 59, 0.7)
- Backdrop Filter: blur(16px)
- Border: 1px solid rgba(255, 255, 255, 0.1)
- Border Radius: 1rem (xl)
- Shadow: lg

#### Game Card

```html
<div class="game-card">
  Content here
</div>
```

- All glass-card properties
- Hover: -translate-y-0.5rem, shadow-xl
- Transition: all 300ms

### Inputs

#### Glass Input

```html
<input class="input-glass" placeholder="Enter text" />
```

- Background: rgba(255, 255, 255, 0.05)
- Border: 1px solid rgba(255, 255, 255, 0.2)
- Border Radius: 0.75rem (xl)
- Padding: 0.75rem 1rem
- Focus: Border primary, ring-2 ring-primary/20
- Hover: Border rgba(255, 255, 255, 0.3)

### Badges

#### Primary Badge

```html
<span class="badge badge-primary">
  Active
</span>
```

- Background: rgba(139, 92, 246, 0.2)
- Text: Primary
- Border: 1px solid rgba(139, 92, 246, 0.3)
- Border Radius: 9999px (full)
- Padding: 0.25rem 0.75rem
- Font Size: 0.75rem (xs)

## Animações

### Duração

```
Fast: 150ms
Normal: 200ms
Slow: 300ms
Slower: 500ms
```

### Timing Functions

```
Default: cubic-bezier(0.4, 0, 0.2, 1)
Enter: cubic-bezier(0.16, 1, 0.3, 1)
Leave: cubic-bezier(0.4, 0, 0.6, 1)
```

### Common Animations

#### Fade In

```css
@keyframes fadeIn {
  0% { opacity: 0; }
  100% { opacity: 1; }
}
```

#### Slide Up

```css
@keyframes slideUp {
  0% {
    transform: translateY(20px);
    opacity: 0;
  }
  100% {
    transform: translateY(0);
    opacity: 1;
  }
}
```

#### Float

```css
@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}
```

#### Pulse Glow

```css
@keyframes pulseGlow {
  0%, 100% {
    box-shadow: 0 0 20px rgba(139, 92, 246, 0.5);
  }
  50% {
    box-shadow: 0 0 40px rgba(139, 92, 246, 0.8);
  }
}
```

## Layout

### Spacing

```
1: 0.25rem (4px)
2: 0.5rem (8px)
3: 0.75rem (12px)
4: 1rem (16px)
5: 1.25rem (20px)
6: 1.5rem (24px)
8: 2rem (32px)
10: 2.5rem (40px)
12: 3rem (48px)
16: 4rem (64px)
```

### Container Max Widths

```
Mobile: 100%
SM: 640px
MD: 768px
LG: 1024px
XL: 1280px
```

### Grid System

- Mobile: 1 column
- Tablet: 2 columns
- Desktop: 3-4 columns
- Gap: 1.5rem (24px)

## Padrões de Uso

### Mobile Navigation

- Bottom navigation bar
- Fixed position
- Glassmorphism background
- 4-5 items max
- Active state com highlight

### Desktop Navigation

- Top navigation bar
- Fixed position
- Glassmorphism background
- Logo + links + user section

### Cards Layout

- Single column no mobile
- 2 columns no tablet
- 3 columns no desktop
- Gap: 1.5rem

### Forms

- Full width inputs
- Clear labels
- Validation states
- Loading states
- Success/error messages

## Acessibilidade

### Cores

- Contraste mínimo 4.5:1 para texto normal
- Contraste mínimo 3:1 para texto grande
- Não usar apenas cor para transmitir informação

### Focus States

- Focus visible em todos os elementos interativos
- Outline ou ring visível
- Não remover outline sem alternativa

### Motion

- Respeitar prefers-reduced-motion
- Animações opcionais
- Sem piscar rápido (risco de epilepsia)

## Performance

### Imagens

- Usar formatos modernos (WebP, AVIF)
- Lazy loading
- Tamanhos apropriados
- Alt text descritivo

### CSS

- Purge unused CSS
- Minify em produção
- Critical CSS inline
- Load fonts com preconnect

### JavaScript

- Code splitting
- Lazy loading
- Tree shaking
- Minify em produção

## Versionamento

Este design system segue versionamento semântico (MAJOR.MINOR.PATCH):

- **MAJOR**: Mudanças breaking
- **MINOR**: Novos componentes (backward compatible)
- **PATCH**: Correções de bugs

## Changelog

### v2.0.1 (2026-05-20) - Bug Fix
- Fixed routing error: Changed `resources :profile` to singular `resource :profile` in routes.rb
- Profile route no longer requires ID parameter (uses current_user)
- Updated navigation components to use correct `profile_path` helper

### v2.0.0 (2026-05-20)
- Adicionado gradientes animados
- Novas animações (blob, gradient, bounce-soft)
- Melhorias no glassmorphism
- Novos Stimulus controllers
- Atualizado Tailwind config
- Documentação expandida

### v1.0.0 (2025-01-01)
- Design system inicial
- Cores e tipografia base
- Componentes principais
- Mobile-first approach
