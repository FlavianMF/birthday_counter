class AuditLog < ApplicationRecord
  # Validations
  validates :action, presence: true

  # Associations
  belongs_to :admin, class_name: 'User', foreign_key: :admin_id, optional: true

  # Scopes
  scope :by_admin, ->(admin_id) { where(admin_id: admin_id) }
  scope :for_resource, ->(resource_type, resource_id) {
    where(resource_type: resource_type, resource_id: resource_id)
  }

  # Methods
  def self.log_action(admin_id, action, resource_type = nil, resource_id = nil, metadata = {})
    create!(
      admin_id: admin_id,
      action: action,
      resource_type: resource_type,
      resource_id: resource_id,
      metadata: metadata
    )
  end
end
