FROM ruby:3.0.2-slim

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  postgresql-client \
  libpq-dev \
  nodejs \
  npm \
  build-essential \
  netcat-openbsd \
  curl \
  && rm -rf /var/lib/apt/lists/*

# Install Node.js dependencies for Tailwind
RUN npm install -g tailwindcss

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Precompile assets (including Tailwind)
RUN bash -c "set -x && gem install tailwindcss-rails && rails tailwindcss:build || echo 'Tailwind build may have warnings'"

# Default command
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && rails server -b 0.0.0.0"]

EXPOSE 3000
