Rails.application.config.after_initialize do
  # Skip database-dependent logic during asset precompilation
  next if ENV['SECRET_KEY_BASE_DUMMY'].present? || ENV['RAILS_ASSETS_PRECOMPILE'].present?

  if ActiveRecord::Base.connected? && ActiveRecord::Base.connection.table_exists?('system_settings')
    SystemSetting.apply_email_settings!
  end
rescue ActiveRecord::NoDatabaseError, PG::ConnectionBad, ActiveRecord::DatabaseConnectionError
  # Do nothing if DB is not ready
end
