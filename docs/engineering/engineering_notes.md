# 🚀 Birthday Counter Engineering Notes

Project implement Birthday Counter Experience. 
Stack: Ruby on Rails 7.1 (FE + BE) + Hotwire + PostgreSQL.
Deploy: Docker Compose on VPS.

## 🗂 Folders
- `app/views`: ERB templates with Tailwind CSS
- `app/javascript`: Stimulus controllers
- `app/assets/stylesheets`: Tailwind CSS with custom design system
- `docs/`: Product & Engineering specs
- `docker/`: Docker configs

## 🛠 Design Decisions

### Frontend Stack
1. **Ruby on Rails 7.1**: Full-stack framework with Hotwire for SPA-like experience
2. **Hotwire (Turbo + Stimulus)**: No JavaScript framework needed, fast dev loop
3. **TailwindCSS 3.0+**: Utility-first CSS with custom design system
4. **Importmap**: No build step for JavaScript modules

### Backend Stack
1. **Ruby on Rails**: MVC architecture, ActiveRecord ORM
2. **PostgreSQL**: Relational data + JSONB for flexible profiles
3. **ActionCable**: Real-time WebSocket for rankings and notifications
4. **Redis**: Caching and real-time features

### Design System
1. **Modern Festive Dark**: Dark theme with vibrant gradients
2. **Glassmorphism**: Backdrop blur effects throughout
3. **Fluid Animations**: Staggered entrance animations, hover effects
4. **Mobile-First**: Bottom navigation, touch-friendly UI

## 📋 Recent Updates (2026-05-20)

### Frontend Improvements
- Updated `tailwind.config.js` with extended animations and colors
- Enhanced `application.tailwind.css` with comprehensive component classes
- Created Stimulus controllers:
  - `countdown_controller.js` - Animated countdown timers
  - `intersection_controller.js` - Scroll-triggered animations
  - `modal_controller.js` - Modal dialogs with animations
  - `tabs_controller.js` - Tabbed interfaces
- Updated all views with enhanced design:
  - Home page with animated hero section
  - Events index with staggered grid
  - Games page with interactive cards
  - Rankings with podium visualization
  - Auth pages with glassmorphism
  - Profile with stats and achievements
- Navigation components updated:
  - Desktop navbar with glass effect
  - Mobile bottom navigation with center action button
- Documentation updated:
  - `FRONTEND.md` - Complete frontend documentation
  - `DESIGN_SYSTEM.md` - New design system reference

### Key Features Added
1. **Animated Background**: Gradient blobs with float animation
2. **Glassmorphism Cards**: Enhanced with backdrop blur and hover effects
3. **Fluid Animations**: Fade-in, slide-up, scale-in throughout
4. **Interactive Buttons**: Scale on hover/active with glow effects
5. **Countdown Timers**: Animated digit transitions
6. **Responsive Design**: Mobile-first with proper breakpoints
7. **Routing Fix**: Changed to singular `resource :profile` for current_user-based routing

### Bug Fixes (v2.0.1)
- Fixed `ActionController::UrlGenerationError` in bottom navigation
- Changed `resources :profile` to `resource :profile` in routes.rb
- Profile path no longer requires ID parameter

## ⚓ Deployment
Docker containers for:
- `web` (Rails app with Puma)
- `db` (PostgreSQL)
- `cache` (Redis)
- `proxy` (Nginx)

## 🎨 Design Tokens

### Colors
- Background: #0F172A (Slate 950)
- Primary: #8B5CF6 → #D946EF (Violet to Fuchsia gradient)
- Secondary: #F59E0B (Amber)
- Accent: #EF4444 (Red)

### Animations
- fade-in, slide-up, slide-down, slide-right
- scale-in, float, pulse-glow
- blob, gradient, bounce-soft
- shimmer (for loading states)

### Components
- .glass-card, .btn-primary, .btn-secondary
- .input-glass, .badge, .stat-card
- .game-card, .feature-card
- .text-gradient, .countdown-digit

## 📈 Next Steps

1. **Real-time Features**: Implement ActionCable for live rankings
2. **PWA**: Add manifest and service worker for offline support
3. **Performance**: Optimize images, lazy load components
4. **Accessibility**: ARIA labels, keyboard navigation
5. **Testing**: Stimulus controller tests, visual regression tests
