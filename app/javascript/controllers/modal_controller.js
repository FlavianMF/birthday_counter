// Modal Controller - For animated modals
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "content"]
  static values = { isOpen: Boolean }

  connect() {
    if (this.isOpenValue) {
      this.open()
    }
  }

  open() {
    this.element.classList.remove('hidden')
    this.element.classList.add('flex')
    
    // Animate overlay
    if (this.overlayTarget) {
      this.overlayTarget.classList.remove('opacity-0')
      this.overlayTarget.classList.add('opacity-100')
    }
    
    // Animate content
    if (this.contentTarget) {
      this.contentTarget.classList.remove('scale-95', 'opacity-0')
      this.contentTarget.classList.add('scale-100', 'opacity-100')
    }
    
    // Prevent body scroll
    document.body.style.overflow = 'hidden'
  }

  close() {
    // Animate overlay out
    if (this.overlayTarget) {
      this.overlayTarget.classList.remove('opacity-100')
      this.overlayTarget.classList.add('opacity-0')
    }
    
    // Animate content out
    if (this.contentTarget) {
      this.contentTarget.classList.remove('scale-100', 'opacity-100')
      this.contentTarget.classList.add('scale-95', 'opacity-0')
    }
    
    // Hide after animation
    setTimeout(() => {
      this.element.classList.add('hidden')
      this.element.classList.remove('flex')
    }, 200)
    
    // Restore body scroll
    document.body.style.overflow = ''
  }

  toggle() {
    if (this.element.classList.contains('hidden')) {
      this.open()
    } else {
      this.close()
    }
  }

  // Close on escape key
  handleKeydown(event) {
    if (event.key === 'Escape') {
      this.close()
    }
  }
}
