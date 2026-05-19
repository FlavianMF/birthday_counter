source "https://rubygems.org"

ruby "3.0.2"

# Rails API
gem "rails", "~> 7.1.0"

# Database
gem "pg", "~> 1.1"

# Web server
gem "puma", ">= 5.0"

# Redis for caching and real-time features
gem "redis", ">= 4.0.1"

# JWT for authentication
gem "jwt"
gem "bcrypt", "~> 3.1.7"

# CORS for cross-origin requests
gem "rack-cors"

# API documentation
gem "rswag"
gem "rswag-ui"

# Background jobs
gem "sidekiq"

# File uploads (S3-compatible)
gem "aws-sdk-s3", require: false

# Geocoding for Geoguessr game
gem "geocoder"

# HTTP client for external APIs (Spotify, etc.)
gem "httparty"

# Environment variables
gem "dotenv-rails", groups: [:development, :test]

# Pagination
gem "kaminari"

# UUID generation
gem "uuid"

platforms :ruby do
  gem "bootsnap", require: false
end

group :development, :test do
  gem "debug", platforms: [:mri, :mswin, :mingw, :x64_mingw]
  gem "factory_bot_rails"
  gem "rspec-rails"
end

group :test do
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
end
