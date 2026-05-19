FROM ruby:3.0.2-slim

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  postgresql-client \
  libpq-dev \
  nodejs \
  npm \
  build-essential \
  netcat-openbsd \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=3

# Copy application code
COPY . .

# Default command
CMD ["./bin/docker-entrypoint"]
