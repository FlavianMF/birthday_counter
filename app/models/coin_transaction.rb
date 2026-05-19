class CoinTransaction < ApplicationRecord
  # Validations
  validates :amount, presence: true
  validates :transaction_type, inclusion: { in: %w[earned spent] }

  # Associations
  belongs_to :user
  belongs_to :event, optional: true

  # Scopes
  scope :earned, -> { where(transaction_type: 'earned') }
  scope :spent, -> { where(transaction_type: 'spent') }
  scope :for_event, ->(event_id) { where(event_id: event_id) }

  # Methods
  def self.total_earned_by_user(user_id)
    where(user_id: user_id, transaction_type: 'earned').sum(:amount)
  end

  def self.total_spent_by_user(user_id)
    where(user_id: user_id, transaction_type: 'spent').sum(:amount)
  end
end
