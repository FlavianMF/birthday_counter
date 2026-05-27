
import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@hotwired/actioncable"

export default class extends Controller {
  static values = {
    eventId: String,
    currentUserId: String
  }

  connect() {
    console.log("Ranking Controller Connected")
    this.subscribe()
  }

  disconnect() {
    if (this.channel) {
      this.channel.unsubscribe()
    }
  }

  subscribe() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "EventChannel", event_id: this.eventIdValue },
      {
        received: (data) => {
          if (data.event_type === "RANKING_UPDATE") {
            this.updateRanking(data.payload)
          }
        }
      }
    )
  }

  updateRanking(payload) {
    console.log("Updating ranking...", payload)
    // For now, we'll just reload the page or a specific turbo frame if we want it simple
    // but the request was to show points, so a reload is better than nothing if real-time is hard
    // but let's try to be smart if the current user is in the top 3
    
    // Simplest robust way: request a refresh of the ranking frame
    const frame = document.getElementById('rankings_list')
    if (frame) {
      frame.src = window.location.href
    } else {
      // Fallback: full reload if no frame
      // window.location.reload()
    }
  }
}
