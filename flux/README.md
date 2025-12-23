# Flux GitOps Configuration

This directory contains Flux CD configuration for GitOps deployment.

## Structure
```
flux/
├── operators/              # Kubernetes Operators
│   ├── cloudnative-pg.yaml    # CloudNativePG Operator (PostgreSQL)
│   ├── dragonfly-operator.yaml # Dragonfly Operator (Redis)
│   └── kustomization.yaml
└── apps/                   # Applications
    ├── dev/                   # Development environment
    │   ├── task-manager.yaml
    │   └── kustomization.yaml
    └── prod/                  # Production environment
        ├── task-manager.yaml
        └── kustomization.yaml
```

## Operators

### CloudNativePG
- **Purpose:** Manages PostgreSQL clusters
- **Version:** 0.22.1
- **Features:** HA, automatic failover, backups

### Dragonfly Operator
- **Purpose:** Manages Dragonfly (Redis) instances
- **Version:** v1.1.7
- **Features:** High performance, Redis compatibility

## Environments

### Development (task-manager-dev)
- Namespace: `task-manager-dev`
- App replicas: 1
- PostgreSQL instances: 1
- Dragonfly replicas: 1
- Image tag: `latest`

### Production (task-manager-prod)
- Namespace: `task-manager-prod`
- App replicas: 3 (HPA: 3-10)
- PostgreSQL instances: 3 (HA)
- Dragonfly replicas: 2 (HA)
- Image tag: `1.0.0`

## Deployment Flow

1. **Operators** are deployed first (via `flux/operators/`)
2. **Applications** depend on operators (via `dependsOn`)
3. **GitOps** automatic sync from Git repository

## Manual Apply (for testing)
```bash
# Apply operators
kubectl apply -k flux/operators/

# Apply dev environment
kubectl apply -k flux/apps/dev/

# Apply prod environment
kubectl apply -k flux/apps/prod/
```

## Monitoring
```bash
# Check Flux status
flux get all

# Check operators
kubectl get helmrelease -n flux-system

# Check applications
kubectl get all -n task-manager-dev
kubectl get all -n task-manager-prod

# Check PostgreSQL clusters
kubectl get cluster -A

# Check Dragonfly instances
kubectl get dragonfly -A
```
