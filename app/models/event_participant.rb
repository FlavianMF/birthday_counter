class EventParticipant < ApplicationRecord
  # Validations
  validates :role, inclusion: { in: %w[host sponsor guest admin] }

  # Associations
  belongs_to :event
  belongs_to :user

  # Scopes
  scope :hosts, -> { where(role: 'host') }
  scope :sponsors, -> { where(role: 'sponsor') }
  scope :guests, -> { where(role: 'guest') }
  scope :accepted, -> { where(has_accepted: true) }
end
