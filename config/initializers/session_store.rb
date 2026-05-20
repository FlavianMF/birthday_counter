# frozen_string_literal: true

# Use the cookie session store with a proper secret key
# Ensure SECRET_KEY_BASE is set in production
Rails.application.config.session_store :cookie_store, 
  key: '_birthday_project_session',
  same_site: :lax,
  expire_after: 14.days,
  secure: Rails.env.production?,
  httponly: true