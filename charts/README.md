# Task Manager Helm Chart

Helm chart for deploying Task Manager REST API with PostgreSQL and Dragonfly (Redis).

## Prerequisites

- Kubernetes 1.28+
- Helm 3.14+
- Dragonfly Operator installed
- Ingress controller (nginx)

## Installation

### Development Environment
```bash
helm install task-manager-dev charts/task-manager \
  -f charts/task-manager/values-dev.yaml \
  --namespace task-manager-dev \
  --create-namespace
```

### Production Environment
```bash
helm install task-manager-prod charts/task-manager \
  -f charts/task-manager/values-prod.yaml \
  --namespace task-manager-prod \
  --create-namespace
```

## Configuration

### Key Values

| Parameter | Description | Default |
|-----------|-------------|---------|
| `app.replicaCount` | Number of app replicas | `1` |
| `app.image.repository` | Docker image repository | `ghcr.io/kingmetok/task-manager-k8s` |
| `app.image.tag` | Docker image tag | `latest` |
| `app.resources.requests.cpu` | CPU request | `100m` |
| `app.resources.requests.memory` | Memory request | `256Mi` |
| `app.autoscaling.enabled` | Enable HPA | `false` |
| `postgresql.enabled` | Deploy PostgreSQL | `true` |
| `postgresql.persistence.size` | PostgreSQL storage | `1Gi` |
| `dragonfly.enabled` | Deploy Dragonfly | `true` |
| `dragonfly.replicas` | Dragonfly replicas | `1` |

### Environment-specific Values

- **Dev:** `values-dev.yaml` - 1 replica, minimal resources, `latest` tag
- **Prod:** `values-prod.yaml` - 3 replicas, HPA enabled, versioned tag

## Testing
```bash
# Lint chart
helm lint charts/task-manager

# Dry-run installation
helm install test charts/task-manager \
  -f charts/task-manager/values-dev.yaml \
  --dry-run --debug

# Template generation
helm template test charts/task-manager \
  -f charts/task-manager/values-dev.yaml \
  > output.yaml
```

## Upgrading
```bash
helm upgrade task-manager-dev charts/task-manager \
  -f charts/task-manager/values-dev.yaml \
  -n task-manager-dev
```

## Uninstall
```bash
helm uninstall task-manager-dev -n task-manager-dev
kubectl delete namespace task-manager-dev
```

## Chart Structure
```
charts/task-manager/
├── Chart.yaml              # Chart metadata
├── values.yaml             # Default values
├── values-dev.yaml         # Development overrides
├── values-prod.yaml        # Production overrides
├── templates/
│   ├── _helpers.tpl        # Template helpers
│   ├── NOTES.txt           # Post-install notes
│   ├── namespace.yaml      # Namespace
│   ├── configmap.yaml      # Application config
│   ├── secret.yaml         # Secrets
│   ├── deployment.yaml     # Application deployment
│   ├── service.yaml        # Application service
│   ├── ingress.yaml        # Ingress rules
│   ├── hpa.yaml            # Horizontal Pod Autoscaler
│   ├── postgresql/         # PostgreSQL resources
│   │   ├── configmap.yaml
│   │   ├── pvc.yaml
│   │   ├── service.yaml
│   │   └── statefulset.yaml
│   └── dragonfly/          # Dragonfly resources
│       └── dragonfly.yaml
└── README.md               # This file
```

## Support

For issues and questions, please open an issue in the GitHub repository.