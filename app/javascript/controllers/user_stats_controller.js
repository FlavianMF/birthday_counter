
import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@hotwired/actioncable"

export default class extends Controller {
  static targets = ["coins", "totalScore", "level", "progress"]
  static values = {
    userId: String
  }

  connect() {
    console.log("User Stats Controller Connected")
    if (this.userIdValue) {
      this.subscribe()
    }
  }

  disconnect() {
    if (this.channel) {
      this.channel.unsubscribe()
    }
  }

  subscribe() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "UserChannel", id: this.userIdValue },
      {
        received: (data) => {
          if (data.event_type === "STATS_UPDATE") {
            this.updateStats(data.payload)
          }
        }
      }
    )
  }

  updateStats(payload) {
    console.log("Updating stats...", payload)
    
    if (this.hasCoinsTarget) {
      this.coinsTarget.textContent = payload.coins
    }
    
    if (this.hasTotalScoreTarget) {
      this.totalScoreTarget.textContent = payload.total_score
    }
    
    // We could calculate level client-side too if we had the formula here
    // level = floor(sqrt(total_score / 100)) + 1
    const level = Math.floor(Math.sqrt(payload.total_score / 100.0)) + 1
    
    if (this.hasLevelTarget) {
      this.levelTargets.forEach(el => el.textContent = `Nível ${level}`)
    }
    
    if (this.hasProgressTarget) {
      const currentLevelBase = Math.pow(level - 1, 2) * 100
      const nextLevelBase = Math.pow(level, 2) * 100
      const totalRange = nextLevelBase - currentLevelBase
      const currentProgress = payload.total_score - currentLevelBase
      const percentage = Math.min(100, Math.max(0, (currentProgress / totalRange) * 100))
      
      this.progressTarget.style.width = `${percentage}%`
    }
  }
}
