// Tabs Controller - For tabbed interfaces
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static values = { active: String }

  connect() {
    this.selectTab(this.activeValue)
  }

  select(id) {
    this.selectTab(id)
  }

  selectTab(tabId) {
    this.activeValue = tabId
    
    // Update tabs
    this.tabTargets.forEach(tab => {
      const isActive = tab.dataset.id === tabId
      tab.setAttribute('aria-selected', isActive)
      tab.classList.toggle('text-primary', isActive)
      tab.classList.toggle('border-b-2', isActive)
      tab.classList.toggle('border-primary', isActive)
      tab.classList.toggle('text-white/60', !isActive)
    })
    
    // Update panels
    this.panelTargets.forEach(panel => {
      const isActive = panel.dataset.id === tabId
      panel.classList.toggle('hidden', !isActive)
      panel.classList.toggle('block', isActive)
      
      if (isActive) {
        panel.classList.add('animate-fade-in')
      }
    })
  }
}
