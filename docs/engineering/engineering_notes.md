# 🚀 Birthday Counter Engineering Notes

Project implement Birthday Counter Experience. 
Stack: Vinext (FE) + FastAPI (BE) + PostgreSQL + Redis.
Deploy: Docker Compose on VPS.

## 🗂 Folders
- `src/frontend`: Vinext app.
- `src/backend`: FastAPI server.
- `docs/`: Product & Engineering specs.
- `docker/`: Docker configs.

## 🛠 Design Decisions
1. **Vinext**: Fast dev loop, Vite speed.
2. **FastAPI**: AI integration ready, Pydantic validation.
3. **Redis**: Real-time rankings + Distributed Locks (Coin spending).
4. **PostgreSQL**: Relational data + JSONB for flexible profiles.

## ⚓ Deployment
Docker containers for:
- `api` (FastAPI)
- `web` (Vinext)
- `db` (Postgres)
- `cache` (Redis)
- `proxy` (Nginx/Traefik)
