// Intersection Observer Controller - For scroll animations
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
        // Add animation class
        const animationClass = this.getAnimationClass()
        entry.target.classList.add(animationClass)
        
        // Optionally unobserve after first intersection
        if (this.data.once !== 'false') {
          this.observer.unobserve(entry.target)
        }
      }
    })
  }

  getAnimationClass() {
    const animations = {
      'fade-in': 'animate-fade-in',
      'slide-up': 'animate-slide-up',
      'slide-down': 'animate-slide-down',
      'slide-right': 'animate-slide-right',
      'scale-in': 'animate-scale-in',
      'float': 'animate-float'
    }
    return animations[this.animationValue] || 'animate-fade-in'
  }
}
