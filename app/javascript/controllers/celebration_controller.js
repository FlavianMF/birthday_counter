import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    emoji: { type: Array, default: ["🎂", "🎉", "✨", "💖", "🥳", "🎈"] }
  }

  connect() {
    console.log("Celebration controller connected")
  }

  // Trigger emoji rain
  rain() {
    const container = document.createElement('div')
    container.className = 'fixed inset-0 pointer-events-none z-[100] overflow-hidden'
    document.body.appendChild(container)

    for (let i = 0; i < 30; i++) {
      this.createEmoji(container)
    }

    // Cleanup after 10 seconds
    setTimeout(() => {
      container.remove()
    }, 10000)
  }

  createEmoji(container) {
    const emoji = document.createElement('div')
    const randomEmoji = this.emojiValue[Math.floor(Math.random() * this.emojiValue.length)]
    
    emoji.textContent = randomEmoji
    emoji.className = 'absolute text-4xl animate-float'
    
    // Random positioning
    const startX = Math.random() * 100
    const startY = -10 - (Math.random() * 50)
    const duration = 3 + (Math.random() * 5)
    const delay = Math.random() * 5
    
    emoji.style.left = `${startX}%`
    emoji.style.top = `${startY}%`
    emoji.style.transition = `top ${duration}s linear ${delay}s, opacity ${duration}s ease-in ${delay}s`
    
    container.appendChild(emoji)
    
    // Animate falling
    requestAnimationFrame(() => {
      setTimeout(() => {
        emoji.style.top = '110%'
        emoji.style.opacity = '0'
      }, 100)
    })
  }
}
