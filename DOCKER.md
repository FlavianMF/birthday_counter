# Docker Commands Cheat Sheet

## Quick Start

```bash
# Start all services
docker-compose up -d

# Start with build
docker-compose up -d --build

# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: deletes data)
docker-compose down -v
```

## Viewing Logs

```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f api
docker-compose logs -f db
docker-compose logs -f redis
docker-compose logs -f sidekiq
```

## Running Commands in Containers

```bash
# Rails console
docker-compose exec api bundle exec rails console

# Database console
docker-compose exec db psql -U postgres -d birthday_counter_development

# Redis CLI
docker-compose exec redis redis-cli

# Run migrations
docker-compose exec api bundle exec rails db:migrate

# Run tests
docker-compose exec api bundle exec rspec

# Bash shell in API container
docker-compose exec api bash
```

## Database Management

```bash
# Create database
docker-compose exec api bundle exec rails db:create

# Drop database
docker-compose exec api bundle exec rails db:drop

# Reset database (drop + create + migrate)
docker-compose exec api bundle exec rails db:reset

# Seed database
docker-compose exec api bundle exec rails db:seed
```

## Health Checks

```bash
# Check container status
docker-compose ps

# Check specific service health
docker inspect --format='{{.State.Health.Status}}' birthday_project-api-1
```

## Production Deployment

```bash
# Build for production
docker-compose -f docker-compose.prod.yml build

# Deploy to production
docker-compose -f docker-compose.prod.yml up -d

# Scale API service
docker-compose -f docker-compose.prod.yml up -d --scale api=3
```

## Troubleshooting

### Container won't start
```bash
# Check logs
docker-compose logs api

# Restart specific service
docker-compose restart api

# Rebuild container
docker-compose up -d --build api
```

### Database connection issues
```bash
# Check if database is ready
docker-compose exec db pg_isready

# Restart database
docker-compose restart db
```

### Redis connection issues
```bash
# Check if Redis is running
docker-compose exec redis redis-cli ping

# Should return: PONG
```

## Environment Variables

Edit `.env` file to configure:

```bash
# Database
POSTGRES_DB=birthday_counter_development
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password

# Rails
RAILS_ENV=development
RAILS_MASTER_KEY=your_master_key

# JWT
JWT_SECRET=your_jwt_secret

# External Services (optional)
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
SPOTIFY_CLIENT_ID=
OPENAI_API_KEY=
```

## Volumes

Data is persisted in Docker volumes:

- `postgres_data`: PostgreSQL database
- `redis_data`: Redis cache data
- `gem_cache`: Ruby gems cache

To remove all data:
```bash
docker-compose down -v
```
