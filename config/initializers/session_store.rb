# frozen_string_literal: true

# Use the cookie session store with a proper secret key
Rails.application.config.session_store :cookie_store, key: '_birthday_project_key', same_site: :strict, expire_after: 14.days