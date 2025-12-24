# 🚀 Task Manager - Kubernetes Course Project

Production-ready Task Manager application deployed on Kubernetes using GitOps principles with FluxCD.

## 📋 Project Overview

This repository contains the complete Infrastructure as Code (IaC) for deploying a Spring Boot Task Manager application on Kubernetes. The project demonstrates advanced Kubernetes concepts including:

- **Multi-stage Docker builds** with optimization
- **Helm charts** with base + overlays pattern
- **Kubernetes Operators** for database management
- **GitOps** workflow with FluxCD
- **Multi-environment setup** (Staging & Production)
- **CI/CD pipeline** with GitHub Actions
- **TLS encryption** with cert-manager

### Application Stack

- **Application**: Spring Boot 4.0.1 Task Manager (Java 21)
- **Database**: PostgreSQL 16 (managed by CloudNativePG Operator)
- **Cache**: Dragonfly (Redis-compatible, managed by Dragonfly Operator)
- **Container Registry**: GitHub Container Registry (GHCR)
- **GitOps**: FluxCD v2.7.5

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        GitHub Repository                        │
│  (Infrastructure as Code + Application Source)                  │
└────────────────┬────────────────────────────────────────────────┘
                 │
                 │ Git Push
                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                     GitHub Actions CI/CD                        │
│  - Build Docker Image (Multi-stage)                             │
│  - Push to GHCR                                                 │
└────────────────┬────────────────────────────────────────────────┘
                 │
                 │ Image Ready
                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                         FluxCD GitOps                           │
│  - Monitors Git Repository                                      │
│  - Auto-deploys changes to Kubernetes                           │
└────────────────┬────────────────────────────────────────────────┘
                 │
        ┌────────┴────────┐
        │                 │
        ▼                 ▼
┌──────────────┐  ┌──────────────────┐
│   STAGING    │  │   PRODUCTION     │
│              │  │                  │
│ • 1 replica  │  │ • HPA 2-5        │
│ • 512Mi RAM  │  │ • 1Gi RAM        │
│ • 1 PG inst  │  │ • 3 PG inst (HA) │
│ • 1 DF repl  │  │ • 2 DF repl (HA) │
└──────────────┘  └──────────────────┘
```

---

## 🎯 Course Stages Completed

### ✅ Stage 1: Containerization

**Objective**: Create optimized Docker image for the application

- ✅ Multi-stage Dockerfile (3 stages: builder, extractor, runtime)
- ✅ Spring Boot layer extraction for optimal caching
- ✅ Distroless base image for security
- ✅ Non-root user (UID 65532)
- ✅ Image pushed to GHCR: \ghcr.io/kingmetok/task-manager-k8s:latest\

**Technologies**: Docker, Multi-stage builds, Distroless, Spring Boot

### ✅ Stage 2: Helm Charts

**Objective**: Create templated Kubernetes manifests

- ✅ Custom Helm chart with full parameterization
- ✅ Base + Overlays pattern (Kustomize)
- ✅ DRY principle - no code duplication
- ✅ Templates for: Deployment, Service, Ingress, ConfigMap, Secret, HPA

**Technologies**: Helm 3, Kustomize

### ✅ Stage 3: Database Operators

**Objective**: Use Kubernetes Operators instead of StatefulSets

- ✅ **CloudNativePG Operator** for PostgreSQL
  - Automatic failover
  - Backup/restore capabilities
  - Connection pooling
- ✅ **Dragonfly Operator** for Redis-compatible cache
  - High performance
  - Memory efficient
- ✅ Operators installed via FluxCD HelmRelease
- ✅ Database instances created via Custom Resources

**Technologies**: CloudNativePG, Dragonfly Operator, Kubernetes CRDs

### ✅ Stage 4: GitOps with FluxCD

**Objective**: Implement GitOps workflow with two environments

- ✅ Flux Bootstrap with GitHub integration
- ✅ Base + Overlays pattern for environment separation
- ✅ **Staging Environment**:
  - Fixed 1 replica
  - Minimal resources (512Mi RAM, 500m CPU)
  - Single PostgreSQL instance
  - Single Dragonfly replica
- ✅ **Production Environment**:
  - HPA: 2-5 replicas
  - Production resources (1Gi RAM, 1000m CPU)
  - HA PostgreSQL (3 instances)
  - HA Dragonfly (2 replicas)

**Technologies**: FluxCD v2.7.5, GitOps, Kustomize

### ✅ Stage 5: CI/CD + TLS

**Objective**: Automate builds and enable HTTPS

- ✅ **GitHub Actions**:
  - Automatic Docker build on push to master
  - Push to GHCR
  - Multi-platform support
  - Build cache optimization
- ✅ **TLS with cert-manager**:
  - Self-signed CA certificates
  - Automatic certificate provisioning
  - HTTPS on all Ingress resources

**Technologies**: GitHub Actions, cert-manager, TLS/SSL

---

## 📂 Repository Structure

```
task-manager-k8s/
├── .github/
│   └── workflows/
│       └── docker-build.yaml          # CI/CD pipeline
│
├── charts/
│   └── task-manager/                  # Custom Helm chart
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── ingress.yaml
│       │   ├── configmap.yaml
│       │   ├── secret.yaml
│       │   ├── hpa.yaml
│       │   ├── postgresql/
│       │   │   └── cluster.yaml       # CloudNativePG Cluster CR
│       │   └── dragonfly/
│       │       └── dragonfly.yaml     # Dragonfly CR
│       ├── values.yaml                # Default values
│       ├── values-staging.yaml        # Staging overrides
│       └── values-production.yaml     # Production overrides
│
├── flux/
│   ├── apps/
│   │   ├── base/                      # Base configuration (DRY)
│   │   │   ├── helmrelease.yaml
│   │   │   └── kustomization.yaml
│   │   ├── staging/                   # Staging overlay
│   │   │   ├── values-patch.yaml
│   │   │   └── kustomization.yaml
│   │   └── production/                # Production overlay
│   │       ├── values-patch.yaml
│   │       └── kustomization.yaml
│   │
│   ├── operators/
│   │   ├── cloudnative-pg.yaml        # PostgreSQL operator
│   │   ├── cert-manager-issuer.yaml   # TLS certificate issuer
│   │   └── kustomization.yaml
│   │
│   └── clusters/production/
│       └── flux-kustomizations.yaml   # Flux bootstrap config
│
├── src/                               # Application source code
│   └── main/
│       ├── java/
│       └── resources/
│
├── Dockerfile                         # Multi-stage build
├── pom.xml                            # Maven configuration
└── README.md                          # This file
```

---

## 🚀 Deployment

### Prerequisites

- Kubernetes cluster (v1.32+)
- kubectl configured
- Flux CLI installed
- GitHub personal access token

### Bootstrap Flux

```bash
flux bootstrap github \
  --owner=kingmetok \
  --repository=task-manager-k8s \
  --branch=master \
  --path=flux/clusters/production \
  --personal \
  --token-auth
```

### Verify Deployment

```bash
# Check Flux status
flux check
flux get all

# Check environments
kubectl get all -n staging
kubectl get all -n production

# Check database operators
kubectl get cluster -A
kubectl get dragonfly -A

# Access applications
# Staging: https://task-manager-staging.127.0.0.1.sslip.io/swagger-ui.html
# Production: https://task-manager-production.127.0.0.1.sslip.io/swagger-ui.html
```

---

## ✅ Verification Commands

### Flux HelmReleases

```bash
flux get helmreleases -A
```

**Expected Output**:
```
NAMESPACE       NAME                    REVISION        SUSPENDED       READY   MESSAGE
flux-system     cloudnative-pg          0.22.1          False           True    Helm upgrade succeeded
flux-system     staging-task-manager    1.0.0           False           True    Helm upgrade succeeded
flux-system     production-task-manager 1.0.0           False           True    Helm upgrade succeeded
```

### Flux Kustomizations

```bash
flux get kustomizations -A
```

**Expected Output**:
```
NAME            REVISION                SUSPENDED       READY   MESSAGE
flux-system     master@sha1:9eaa6975    False           True    Applied revision: master@sha1:9eaa6975
operators       master@sha1:9eaa6975    False           True    Applied revision: master@sha1:9eaa6975
staging         master@sha1:9eaa6975    False           True    Applied revision: master@sha1:9eaa6975
production      master@sha1:9eaa6975    False           True    Applied revision: master@sha1:9eaa6975
```

### All Pods

```bash
kubectl get pods -A
```

**Key Namespaces**:
- \staging\: 1 app pod, 1 PostgreSQL, 1 Dragonfly
- \production\: 2+ app pods (HPA), 3 PostgreSQL (HA), 2 Dragonfly (HA)
- \flux-system\: Flux controllers
- \cnpg-system\: CloudNativePG operator
- \cert-manager\: Certificate management

### Ingress Resources

```bash
kubectl get ingress -A
```

**Expected Output**:
```
NAMESPACE    NAME                      CLASS   HOSTS                                          ADDRESS     PORTS     AGE
staging      task-manager-staging      nginx   task-manager-staging.127.0.0.1.sslip.io       localhost   80, 443   4h
production   task-manager-production   nginx   task-manager-production.127.0.0.1.sslip.io    localhost   80, 443   4h
```

### Self-Healing Test

```bash
# Delete deployment
kubectl delete deployment -n staging task-manager-staging

# Wait 30 seconds
sleep 30

# Verify auto-recovery
kubectl get deployment -n staging
# STATUS: Deployment should be recreated by Flux
```

---

## 🔧 Environment Comparison

| Feature | Staging | Production |
|---------|---------|------------|
| **Replicas** | 1 (fixed) | 2-5 (HPA) |
| **CPU Limit** | 500m | 1000m |
| **Memory Limit** | 512Mi | 1Gi |
| **PostgreSQL** | 1 instance | 3 instances (HA) |
| **Dragonfly** | 1 replica | 2 replicas (HA) |
| **Autoscaling** | Disabled | Enabled |
| **Domain** | task-manager-staging.127.0.0.1.sslip.io | task-manager-production.127.0.0.1.sslip.io |

---

## 🛠️ Technologies Used

### Core Stack
- **Kubernetes**: v1.34.1 (Container orchestration)
- **FluxCD**: v2.7.5 (GitOps)
- **Helm**: v3 (Package management)
- **Kustomize**: (Configuration management)

### Application
- **Spring Boot**: 4.0.1
- **Java**: 21 (Eclipse Temurin)
- **Maven**: 3.9.6

### Database & Cache
- **PostgreSQL**: 16 (via CloudNativePG Operator v0.22.1)
- **Dragonfly**: v1.23.1 (Redis-compatible)

### DevOps
- **GitHub Actions**: CI/CD automation
- **GHCR**: Container registry
- **cert-manager**: v1.14.2 (TLS certificates)
- **ingress-nginx**: Ingress controller

---

## 🎓 Key Achievements

### Production-Ready Architecture
✅ Multi-stage Docker builds with layer optimization  
✅ Distroless runtime for minimal attack surface  
✅ High Availability setup in production  
✅ Horizontal Pod Autoscaling  
✅ TLS encryption on all endpoints  

### Best Practices
✅ GitOps workflow - infrastructure versioned in Git  
✅ Base + Overlays pattern - DRY principle  
✅ Operator pattern for stateful workloads  
✅ Resource limits and requests configured  
✅ Health checks (liveness & readiness probes)  
✅ Non-root container execution  

### Automation
✅ Automatic Docker builds on commit  
✅ Auto-deployment via FluxCD  
✅ Self-healing infrastructure  
✅ Automatic certificate provisioning  

---

## 📊 Course Project Results

- ✅ **Stage 1**: Containerization with optimization
- ✅ **Stage 2**: Helm charts with templating
- ✅ **Stage 3**: Kubernetes Operators for databases
- ✅ **Stage 4**: GitOps with multi-environment setup
- ✅ **Stage 5**: CI/CD pipeline + TLS encryption

**All stages completed successfully with additional best practices implemented!**

---

## 📝 License

This is a course project for educational purposes.

---

## 👤 Author

**Mykhailo Pinchuk**  
Kubernetes Course - Final Project  

---

## 🔗 Links

- **Repository**: https://github.com/kingmetok/task-manager-k8s
- **Staging**: https://task-manager-staging.127.0.0.1.sslip.io/swagger-ui.html
- **Production**: https://task-manager-production.127.0.0.1.sslip.io/swagger-ui.html
- **Container Registry**: https://github.com/kingmetok/task-manager-k8s/pkgs/container/task-manager-k8s

---

Last Updated: 2025-12-24
