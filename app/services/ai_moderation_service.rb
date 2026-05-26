class AiModerationService
  OFFENSIVE_KEYWORDS = %w[badword1 badword2 badword3] # Mock list

  def self.offensive?(content)
    return false if content.blank?
    OFFENSIVE_KEYWORDS.any? { |word| content.downcase.include?(word) }
  end

  def self.generate_fact_or_fiction(bio_storytelling)
    # In a real app, this would call an LLM (OpenAI, Gemini, etc.)
    # Here we mock the response
    {
      facts: ["Fact 1 from bio", "Fact 2 from bio"],
      fiction: "A plausible lie created by AI"
    }
  end
end
