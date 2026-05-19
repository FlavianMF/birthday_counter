class MediaRepository < ApplicationRecord
  # Validations
  validates :media_type, inclusion: { in: %w[image video audio] }
  validates :url, presence: true

  # Associations
  belongs_to :event
  belongs_to :uploader, class_name: 'User', foreign_key: :uploader_id, optional: true

  # Scopes
  scope :for_event, ->(event_id) { where(event_id: event_id) }
  scope :images, -> { where(media_type: 'image') }
  scope :videos, -> { where(media_type: 'video') }
  scope :with_date, -> { where.not('date_taken IS NULL') }

  # Callbacks
  after_create :extract_metadata

  def extract_metadata
    # Extract GPS coordinates from image metadata if available
    # This would typically use a library like exiftool
  end

  # Methods
  def has_gps?
    metadata.present? && metadata['gps'].present?
  end

  def gps_coordinates
    return nil unless has_gps?
    metadata['gps']
  end
end
