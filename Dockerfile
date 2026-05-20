FROM ruby:3.0.2-slim

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
  postgresql-client \
  libpq-dev \
  nodejs \
  npm \
  build-essential \
  netcat-openbsd \
  curl \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Install npm dependencies
COPY package.json ./
RUN npm install

# Copy application code
COPY . .

# Set environment variables for precompilation ONLY
# We use a subshell for precompilation to avoid leaking these to the final image
RUN RAILS_ENV=production \
    SECRET_KEY_BASE_DUMMY=1 \
    DATABASE_URL=postgresql://postgres@localhost/dummy_db \
    bundle exec rails tailwindcss:build && \
    ./node_modules/.bin/esbuild app/javascript/application.js --bundle --sourcemap --outdir=app/assets/builds --public-path=/assets && \
    cp app/assets/builds/tailwind.css app/assets/builds/application.css && \
    bundle exec rails assets:precompile

# For development, we ensure the builds folder is accessible
RUN mkdir -p tmp/cache/assets && chmod -R 777 tmp/cache

# Default command
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0"]

EXPOSE 3000
