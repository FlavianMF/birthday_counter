# Birthday Counter Visual Concepts

Based on the documentation in `@docs/**`, here is the imagined layout and design for the application.

## 1. Visual Identity: "Modern Festive Dark"

The application uses a deep Slate background (`#0F172A`) to make celebratory elements pop. Glassmorphism is the primary UI pattern, using semi-transparent surfaces with backdrop blur to create depth and a premium feel.

### Key Elements:
- **Palette**: Slate 950 (BG), Violet-to-Fuchsia Gradients (Primary), Amber (Coins), Emerald (Success).
- **Typography**: Montserrat for bold headings, Inter for readable body text, and JetBrains Mono for the high-precision countdown digits.
- **Vibe**: Energetic, polished, and interactive.

## 2. Core Screens

### 2.1 Landing Page
The landing page focuses on the "Minuto Zero" hook. It features:
- A large, animated countdown card.
- Floating background blobs in Violet and Fuchsia.
- High-contrast CTAs with glowing hover effects.
- **Mockup**: [landing_page_mockup.svg](./landing_page_mockup.svg)

### 2.2 Event Dashboard (Mobile-First)
The heart of the experience for guests. It includes:
- **Header**: Quick info about the host and current status.
- **Sticky Countdown**: Always visible to maintain the sense of anticipation.
- **Coins Wallet**: A golden badge showing the user's current currency.
- **Glass Cards**: Interactive cards for Games (Geoguessr, Fact or Fiction) and the Time Capsule.
- **Bottom Navigation**: Ergonomic access to Home, Games, Rankings, and Profile.
- **Mockup**: [event_dashboard_mockup.svg](./event_dashboard_mockup.svg)

### 2.3 Gamification: Memory Geoguessr
- **Interface**: A full-screen interactive map with a floating picture of a memory.
- **Interaction**: Users drop a pin on the map. Upon submission, a line connects their guess to the real location with an animated score popup.

## 3. Interaction Design
- **Fluidity**: Every transition uses `framer-motion` for spring-based animations.
- **Feedback**: Immediate visual response for game actions (confetti for wins, subtle shakes for errors).
- **Anticipation**: The closer the countdown gets to zero, the more frequent the "pulse" animations and particle effects become.

---
*Created by Gemini CLI based on project documentation.*
