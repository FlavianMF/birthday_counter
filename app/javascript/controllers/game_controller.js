import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["score", "progressBar", "instructions", "statements", "feedback", "resultIcon", "resultTitle", "resultMessage"]
  static values = {
    fiction: String,
    eventId: String
  }

  connect() {
    console.log("Game Controller Connected!")
    window.alert("Game Connected!")
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
        btn.classList.add('border-green-500/50', 'bg-green-500/10')
      } else if (stmt === selectedStatement && !isCorrect) {
        btn.classList.add('border-red-500/50', 'bg-red-500/10')
      }
    })

    // Prepare Feedback
    if (isCorrect) {
      this.resultIconTarget.textContent = "🎉"
      this.resultTitleTarget.textContent = "Acertou!"
      this.resultTitleTarget.className = "text-3xl font-bold text-green-400 mb-2"
      this.resultMessageTarget.textContent = "Você detectou a mentira da IA!"
      this.scoreTarget.textContent = "500"
    } else {
      this.resultIconTarget.textContent = "❌"
      this.resultTitleTarget.textContent = "Errou!"
      this.resultTitleTarget.className = "text-3xl font-bold text-red-400 mb-2"
      this.resultMessageTarget.textContent = "A mentira era: " + this.fictionValue
    }

    // Call API to persist score
    try {
      const response = await fetch(`/api/v1/events/${this.eventIdValue}/games/fact-or-fiction/play`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ is_correct: isCorrect })
      })
      
      if (response.ok) {
        const data = await response.json()
        console.log("Score persisted:", data)
      }
    } catch (error) {
      console.error("Error persisting score:", error)
    }

    // Show feedback
    this.feedbackTarget.classList.remove('hidden')
  }
}
