// Countdown Controller - Enhanced with animations
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

      // Animate only if value changed
      if (this.daysTarget.textContent !== this.pad(days)) {
        this.animateValue(this.daysTarget, this.pad(days))
      }
      if (this.hoursTarget.textContent !== this.pad(hours)) {
        this.animateValue(this.hoursTarget, this.pad(hours))
      }
      if (this.minutesTarget.textContent !== this.pad(minutes)) {
        this.animateValue(this.minutesTarget, this.pad(minutes))
      }
      if (this.secondsTarget.textContent !== this.pad(seconds)) {
        this.animateValue(this.secondsTarget, this.pad(seconds))
      }
    } else {
      // Countdown finished
      this.element.dispatchEvent(new CustomEvent('countdown-finished'))
    }
  }

  animateValue(element, newValue) {
    // Add animation class
    element.classList.add('scale-110', 'text-fuchsia-400')
    element.classList.remove('text-transparent')
    
    setTimeout(() => {
      element.textContent = newValue
      element.classList.remove('scale-110', 'text-fuchsia-400')
      element.classList.add('text-transparent')
    }, 150)
  }

  pad(num) {
    return num.toString().padStart(2, '0')
  }
}
