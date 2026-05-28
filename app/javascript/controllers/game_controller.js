import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["score", "progressBar", "instructions", "statements", "feedback", "resultIcon", "resultTitle", "resultMessage", "earnedPoints", "earnedCoins"]
  static values = {
    fiction: String,
    eventId: String
  }

  connect() {
    console.log("Game Controller Connected!")
    this.hasPlayed = false
  }

  async guess(event) {
    console.log("Guess clicked!", event.currentTarget.dataset.statement)
    if (this.hasPlayed) return

    const selectedStatement = event.currentTarget.dataset.statement
    const isCorrect = selectedStatement === this.fictionValue
    this.hasPlayed = true

    // UI Updates
    this.instructionsTarget.classList.add('hidden')
    this.statementsTarget.classList.add('opacity-50', 'pointer-events-none')
    this.progressBarTarget.style.width = "100%"

    // Highlight correct/incorrect on buttons
    this.statementsTarget.querySelectorAll('button').forEach(btn => {
      const stmt = btn.dataset.statement
      if (stmt === this.fictionValue) {
        btn.classList.add('border-green-500/50', 'bg-green-500/10', 'ring-2', 'ring-green-500/50')
      } else if (stmt === selectedStatement && !isCorrect) {
        btn.classList.add('border-red-500/50', 'bg-red-500/10', 'ring-2', 'ring-red-500/50')
      }
    })

    // Prepare Feedback (Preliminary)
    if (isCorrect) {
      this.resultIconTarget.textContent = "🎉"
      this.resultTitleTarget.textContent = "Acertou!"
      this.resultTitleTarget.className = "text-3xl font-bold text-green-400 mb-2"
      this.resultMessageTarget.textContent = "Você detectou a mentira da IA!"
      this.earnedPointsTarget.textContent = "Calculando..."
      this.earnedCoinsTarget.textContent = "..."
      
      // Trigger celebration if available
      const celebration = this.application.getControllerForElementAndIdentifier(document.body, 'celebration')
      if (celebration) celebration.rain()
    } else {
      this.resultIconTarget.textContent = "❌"
      this.resultTitleTarget.textContent = "Errou!"
      this.resultTitleTarget.className = "text-3xl font-bold text-red-400 mb-2"
      this.resultMessageTarget.textContent = "A mentira era: " + this.fictionValue
      this.earnedPointsTarget.textContent = "+0"
      this.earnedCoinsTarget.textContent = "+0 💰"
    }

    // Call internal play action to persist score
    try {
      console.log("Persistence Payload:", { is_correct: isCorrect })
      const response = await fetch(`/events/${this.eventIdValue}/games/play`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ is_correct: isCorrect })
      })
      
      if (response.ok) {
        const data = await response.json()
        console.log("Score persisted:", data)
        
        // Update with real values from server (including multipliers)
        if (data.is_correct) {
          this.scoreTarget.textContent = data.new_total_score
          this.earnedPointsTarget.textContent = `+${data.score}`
          this.earnedCoinsTarget.textContent = `+${data.coins_earned} 💰`
        } else {
          // Even if wrong, new_total_score might have changed due to streak maintenance (though points 0)
          this.scoreTarget.textContent = data.new_total_score
        }
      }
    } catch (error) {
      console.error("Error persisting score:", error)
    }

    // Show feedback
    this.feedbackTarget.classList.remove('hidden')
  }
}
