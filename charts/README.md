# Task Manager Helm Chart

Production-ready Helm chart for deploying the Task Manager Spring Boot application with PostgreSQL and Dragonfly cache.

## 📋 Overview

This chart deploys a complete Task Manager stack including:
- **Application**: Spring Boot 4.0.1 Task Manager
- **Database**: PostgreSQL 16 (via CloudNativePG Operator)
- **Cache**: Dragonfly (Redis-compatible)
- **Ingress**: NGINX Ingress with TLS support
- **Autoscaling**: Horizontal Pod Autoscaler (optional)

---

## 📁 Chart Structure

```
task-manager/
├── Chart.yaml                 # Chart metadata
├── values.yaml                # Default values
├── values-staging.yaml        # Staging environment overrides
├── values-production.yaml     # Production environment overrides
│
├── templates/
│   ├── _helpers.tpl           # Template helpers
│   ├── NOTES.txt              # Post-install notes
│   │
│   ├── namespace.yaml         # Namespace definition
│   ├── configmap.yaml         # Application configuration
│   ├── secret.yaml            # Database credentials reference
│   ├── deployment.yaml        # Application deployment
│   ├── service.yaml           # ClusterIP service
│   ├── ingress.yaml           # Ingress resource
│   ├── hpa.yaml               # Horizontal Pod Autoscaler
│   │
│   ├── postgresql/
│   │   └── cluster.yaml       # CloudNativePG Cluster CR
│   │
│   └── dragonfly/
│       └── dragonfly.yaml     # Dragonfly CR
│
└── README.md                  # This file
```

---

## 🚀 Quick Start

### Prerequisites

- Kubernetes cluster v1.32+
- Helm v3+
- CloudNativePG Operator installed
- Dragonfly Operator installed
- NGINX Ingress Controller

### Install Chart

```bash
# Development (default values)
helm install task-manager ./task-manager

# Staging environment
helm install task-manager-staging ./task-manager \
  -f values-staging.yaml \
  -n staging --create-namespace

# Production environment
helm install task-manager-production ./task-manager \
  -f values-production.yaml \
  -n production --create-namespace
```

### Upgrade Chart

```bash
helm upgrade task-manager-staging ./task-manager \
  -f values-staging.yaml \
  -n staging
```

### Uninstall Chart

```bash
helm uninstall task-manager-staging -n staging
```

---

## ⚙️ Configuration

### values.yaml Structure

```yaml
app:
  replicaCount: 1
  image:
    repository: ghcr.io/kingmetok/task-manager-k8s
    tag: "latest"
    pullPolicy: IfNotPresent
  
  resources:
    requests:
      cpu: 100m
      memory: 256Mi
    limits:
      cpu: 500m
      memory: 512Mi
  
  ingress:
    enabled: true
    className: nginx
    hosts:
      - host: task-manager.127.0.0.1.sslip.io
        paths:
          - path: /
            pathType: Prefix
    tls:
      enabled: true
      secretName: task-manager-tls
      issuer: ca-issuer
  
  autoscaling:
    enabled: false
    minReplicas: 2
    maxReplicas: 10
    targetCPUUtilizationPercentage: 70
    targetMemoryUtilizationPercentage: 80

postgresql:
  enabled: true
  instances: 1
  image:
    registry: docker.io
    repository: postgres
    tag: "16"
  persistence:
    size: 10Gi
  resources:
    requests:
      cpu: 100m
      memory: 256Mi
    limits:
      cpu: 500m
      memory: 512Mi
  postgresUID: 999
  postgresGID: 999
  enableSuperuserAccess: true

dragonfly:
  enabled: true
  replicas: 1
  image:
    registry: docker.dragonflydb.io
    repository: dragonflydb/dragonfly
    tag: "v1.23.1"
  resources:
    requests:
      cpu: 100m
      memory: 128Mi
    limits:
      cpu: 250m
      memory: 256Mi

namespace:
  name: default
  create: false
```

---

## 🔧 Key Parameters

### Application

| Parameter | Description | Default |
|-----------|-------------|---------|
| \app.replicaCount\ | Number of replicas | \1\ |
| \app.image.repository\ | Image repository | \ghcr.io/kingmetok/task-manager-k8s\ |
| \app.image.tag\ | Image tag | \latest\ |
| \app.image.pullPolicy\ | Image pull policy | \IfNotPresent\ |
| \app.resources.requests.cpu\ | CPU request | \100m\ |
| \app.resources.requests.memory\ | Memory request | \256Mi\ |
| \app.resources.limits.cpu\ | CPU limit | \500m\ |
| \app.resources.limits.memory\ | Memory limit | \512Mi\ |

### Ingress

| Parameter | Description | Default |
|-----------|-------------|---------|
| \app.ingress.enabled\ | Enable Ingress | \	rue\ |
| \app.ingress.className\ | Ingress class | \
ginx\ |
| \app.ingress.hosts[0].host\ | Hostname | \	ask-manager.127.0.0.1.sslip.io\ |
| \app.ingress.tls.enabled\ | Enable TLS | \	rue\ |
| \app.ingress.tls.issuer\ | cert-manager issuer | \ca-issuer\ |

### Autoscaling

| Parameter | Description | Default |
|-----------|-------------|---------|
| \app.autoscaling.enabled\ | Enable HPA | \alse\ |
| \app.autoscaling.minReplicas\ | Minimum replicas | \2\ |
| \app.autoscaling.maxReplicas\ | Maximum replicas | \10\ |
| \app.autoscaling.targetCPUUtilizationPercentage\ | Target CPU % | \70\ |
| \app.autoscaling.targetMemoryUtilizationPercentage\ | Target Memory % | \80\ |

### PostgreSQL

| Parameter | Description | Default |
|-----------|-------------|---------|
| \postgresql.enabled\ | Enable PostgreSQL | \	rue\ |
| \postgresql.instances\ | Number of instances | \1\ |
| \postgresql.image.tag\ | PostgreSQL version | \16\ |
| \postgresql.persistence.size\ | Storage size | \10Gi\ |
| \postgresql.enableSuperuserAccess\ | Enable superuser | \	rue\ |

### Dragonfly

| Parameter | Description | Default |
|-----------|-------------|---------|
| \dragonfly.enabled\ | Enable Dragonfly | \	rue\ |
| \dragonfly.replicas\ | Number of replicas | \1\ |
| \dragonfly.image.tag\ | Dragonfly version | \1.23.1\ |

---

## 🎯 Environment Presets

### Staging (\alues-staging.yaml\)

Optimized for testing with minimal resources:

```yaml
app:
  replicaCount: 1
  resources:
    limits:
      cpu: 500m
      memory: 512Mi
  autoscaling:
    enabled: false

postgresql:
  instances: 1  # Single instance

dragonfly:
  replicas: 1   # Single replica
```

**Use Case**: Development, testing, CI/CD pipelines

### Production (\values-production.yaml\)

Optimized for high availability and performance:

```yaml
app:
  replicaCount: 2
  resources:
    limits:
      cpu: 1000m
      memory: 1Gi
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 5

postgresql:
  instances: 3  # High Availability
  persistence:
    size: 10Gi

dragonfly:
  replicas: 2   # High Availability
```

**Use Case**: Production workloads requiring HA and auto-scaling

---

## 📊 Templates Explained

### deployment.yaml

Deploys the Spring Boot application with:
- **Health Probes**: Liveness and readiness checks
- **Environment Variables**: Database and cache configuration
- **Resource Limits**: CPU and memory constraints
- **Security**: Non-root user, read-only root filesystem

```yaml
livenessProbe:
  httpGet:
    path: /actuator/health/liveness
    port: 8080
  initialDelaySeconds: 60
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /actuator/health/readiness
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10
```

### postgresql/cluster.yaml

Creates a CloudNativePG Cluster with:
- **Automatic Failover**: High availability
- **Superuser Access**: Application connectivity
- **Resource Management**: Configurable CPU/memory
- **Storage**: Persistent volumes

### dragonfly/dragonfly.yaml

Creates a Dragonfly instance with:
- **Memory Management**: Configurable maxmemory
- **Health Checks**: Built-in healthcheck scripts
- **Performance**: Multi-threaded proactor

### hpa.yaml

Horizontal Pod Autoscaler for dynamic scaling based on:
- CPU utilization (70% target)
- Memory utilization (80% target)

---

## 🔐 Secrets Management

The chart references secrets created by operators:

### PostgreSQL Secret

Created by CloudNativePG operator:
```
<release-name>-postgresql-superuser
  - username
  - password
```

### Usage in Deployment

```yaml
env:
  - name: DB_USER
    valueFrom:
      secretKeyRef:
        name: {{ .Release.Name }}-postgresql-superuser
        key: username
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ .Release.Name }}-postgresql-superuser
        key: password
```

---

## 🛠️ Debugging

### Check Rendered Templates

```bash
# Render templates without installing
helm template task-manager ./task-manager -f values-staging.yaml

# Dry-run install
helm install task-manager ./task-manager \
  -f values-staging.yaml \
  --dry-run --debug
```

### Check Deployed Values

```bash
# Get values of installed release
helm get values task-manager-staging -n staging

# Get all computed values
helm get values task-manager-staging -n staging --all
```

### Validate Chart

```bash
# Lint chart
helm lint ./task-manager

# Test with different values
helm lint ./task-manager -f values-staging.yaml
helm lint ./task-manager -f values-production.yaml
```

---

## 🔄 Upgrade Strategy

### Rolling Update

```yaml
# deployment.yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

This ensures:
- Zero downtime during updates
- New pods start before old ones terminate
- Gradual rollout of changes

---

## 📈 Monitoring

### Health Endpoints

- **Liveness**: \/actuator/health/liveness\
- **Readiness**: \/actuator/health/readiness\
- **Full Health**: \/actuator/health\

### Metrics

Spring Boot Actuator provides metrics at:
- \/actuator/metrics\
- \/actuator/prometheus\ (if micrometer-prometheus is enabled)

---

## 🧪 Testing

### Install and Test

```bash
# Install
helm install test-release ./task-manager \
  -f values-staging.yaml \
  -n test --create-namespace

# Wait for pods
kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/name=task-manager \
  -n test --timeout=300s

# Test application
kubectl port-forward -n test svc/test-release 8080:8080

# Access: http://localhost:8080/swagger-ui.html

# Cleanup
helm uninstall test-release -n test
kubectl delete namespace test
```

---

## 📖 Template Helpers

Located in \	emplates/_helpers.tpl\:

- \	ask-manager.name\: Chart name
- \	ask-manager.fullname\: Full resource name
- \	ask-manager.labels\: Common labels
- \	ask-manager.selectorLabels\: Selector labels

### Usage Example

```yaml
metadata:
  name: {{ include "task-manager.fullname" . }}
  labels:
    {{- include "task-manager.labels" . | nindent 4 }}
```

---

## ⚠️ Important Notes

1. **Operator Dependencies**: CloudNativePG and Dragonfly operators must be installed before deploying this chart
2. **Namespace Creation**: Set \
amespace.create: true\ if namespace doesn't exist
3. **TLS Certificates**: cert-manager must be installed for TLS to work
4. **Resource Limits**: Always set appropriate limits based on your workload

---

## 🔗 Related Documentation

- [Helm Documentation](https://helm.sh/docs/)
- [CloudNativePG Operator](https://cloudnative-pg.io/)
- [Dragonfly Documentation](https://www.dragonflydb.io/)
- [NGINX Ingress](https://kubernetes.github.io/ingress-nginx/)

---

**Chart Version**: 1.0.0  
**App Version**: 1.0.0  
**Last Updated**: 2025-12-24
