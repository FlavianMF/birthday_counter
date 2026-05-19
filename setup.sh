#!/bin/bash

# Birthday Counter Experience - Setup Script
# This script sets up the development environment using Docker

set -e

echo "🎂 Birthday Counter Experience - Docker Setup"
echo "=============================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
echo ""

# Copy environment file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp .env.docker .env
    echo "✅ .env file created. Please update with your configuration."
    echo ""
fi

# Start services
echo "🚀 Starting Docker containers..."
docker-compose up -d

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check if services are healthy
echo ""
echo "📊 Service Status:"
docker-compose ps

echo ""
echo "✅ Setup complete!"
echo ""
echo "📱 Application URLs:"
echo "   - API: http://localhost:3000"
echo "   - Health: http://localhost:3000/health"
echo ""
echo "📦 Database:"
echo "   - Host: localhost:5432"
echo "   - Database: birthday_counter_development"
echo "   - User: postgres"
echo "   - Password: postgres"
echo ""
echo "🔴 Redis:"
echo "   - Host: localhost:6379"
echo ""
echo "📝 Useful commands:"
echo "   - View logs: docker-compose logs -f"
echo "   - Stop: docker-compose down"
echo "   - Restart: docker-compose restart"
echo "   - Rebuild: docker-compose up -d --build"
echo "   - Database console: docker-compose exec db psql -U postgres -d birthday_counter_development"
echo ""
