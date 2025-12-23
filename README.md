# Task Manager REST API

A simple task management REST API built with Spring Boot, PostgreSQL, and Redis (Dragonfly) caching.

## Features

- ✅ CRUD operations for tasks
- ✅ PostgreSQL for persistent storage
- ✅ Redis/Dragonfly for caching
- ✅ OpenAPI/Swagger documentation
- ✅ Health checks for Kubernetes
- ✅ Multi-stage Docker build
- ✅ Production-ready configuration

## Tech Stack

- **Java 21**
- **Spring Boot 4.0.1**
- **PostgreSQL** (database)
- **Redis/Dragonfly** (cache)
- **Maven** (build tool)
- **Swagger/OpenAPI 3.0** (API docs)

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tasks` | Get all tasks (cached) |
| GET | `/api/tasks/{id}` | Get task by ID (cached) |
| POST | `/api/tasks` | Create new task |
| PUT | `/api/tasks/{id}` | Update task |
| DELETE | `/api/tasks/{id}` | Delete task |
| GET | `/api/tasks/status/{completed}` | Get tasks by status |

## Health Checks

- **Liveness:** `/actuator/health/liveness`
- **Readiness:** `/actuator/health/readiness`
- **General Health:** `/actuator/health`

## Swagger UI

Access API documentation at: `http://localhost:8080/swagger-ui.html`

## Local Development

### Prerequisites

- Java 21
- Maven 3.9+
- PostgreSQL 15+
- Redis or Dragonfly

### Run with Docker Compose
```bash
docker-compose up -d
```

### Build and Run
```bash
# Build
mvn clean package

# Run
java -jar target/task-manager-1.0.0.jar
```

## Docker Build
```bash
# Build image
docker build -t task-manager:1.0.0 .

# Run container
docker run -p 8080:8080 \
  -e DB_HOST=postgres \
  -e DB_PORT=5432 \
  -e DB_NAME=taskmanager \
  -e DB_USER=postgres \
  -e DB_PASSWORD=postgres \
  -e REDIS_HOST=redis \
  -e REDIS_PORT=6379 \
  task-manager:1.0.0
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DB_HOST` | PostgreSQL host | localhost |
| `DB_PORT` | PostgreSQL port | 5432 |
| `DB_NAME` | Database name | taskmanager |
| `DB_USER` | Database user | postgres |
| `DB_PASSWORD` | Database password | postgres |
| `REDIS_HOST` | Redis/Dragonfly host | localhost |
| `REDIS_PORT` | Redis/Dragonfly port | 6379 |

# Task Manager REST API

[![Build and Push Docker Image](https://github.com/USERNAME/task-manager-k8s/actions/workflows/docker-build.yml/badge.svg)](https://github.com/USERNAME/task-manager-k8s/actions/workflows/docker-build.yml)

Kubernetes course project - Task Management REST API with PostgreSQL and Redis caching.

## Docker Image
```bash
docker pull ghcr.io/kingmetok/task-manager-k8s:latest
```

## Features

- ✅ CRUD REST API for task management
- ✅ PostgreSQL for data persistence
- ✅ Redis (Dragonfly) for caching
- ✅ Multi-stage Docker build (~350 MB)
- ✅ Kubernetes ready (health checks, probes)
- ✅ OpenAPI/Swagger documentation

## Quick Start
```bash
# Pull image
docker pull ghcr.io/kingmetok/task-manager-k8s:latest

# Run with docker-compose
docker-compose up -d

# Access Swagger UI
open http://localhost:8080/swagger-ui.html