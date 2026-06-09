class AppSetting < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  def self.get(key, default = nil)
    setting = find_by(key: key)
    setting ? setting.value : default
  end

  def self.set(key, value)
    setting = find_or_initialize_by(key: key)
    setting.value = value
    setting.save
  end

  def self.email_config
    get('email_config', {
      'smtp_address' => 'mailpit',
      'smtp_port' => 1025,
      'from_email' => 'birthday@example.com'
    })
  end
end
