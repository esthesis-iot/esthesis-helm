# esthesis CORE Kubernetes Deployment Guide

This guide walks you through deploying esthesis CORE on a Kubernetes cluster.

## Prerequisites

- Kubernetes cluster (v1.25+) with at least 3 nodes
- `kubectl` configured to access your cluster
- `helm` v3.12+ installed
- Load Balancer support (or NodePort for local clusters)
- Ingress controller (or install via this chart)

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    esthesis-core-operators                       │
│  (Install First - Cluster-scoped)                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │   Strimzi   │  │   Percona   │  │   Percona   │              │
│  │   Kafka     │  │   MongoDB   │  │ PostgreSQL  │              │
│  │  Operator   │  │  Operator   │  │  Operator   │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                      esthesis-core-deps                          │
│  (Install Second - Namespace-scoped)                            │
│  ┌───────┐ ┌───────┐ ┌───────┐ ┌──────────┐ ┌────────┐         │
│  │ Kafka │ │MongoDB│ │Postgre│ │ Keycloak │ │InfluxDB│ ...     │
│  │Cluster│ │Cluster│ │Cluster│ │          │ │        │         │
│  └───────┘ └───────┘ └───────┘ └──────────┘ └────────┘         │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                        esthesis-core                             │
│  (Install Third - Application)                                  │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │             esthesis CORE Application Components            ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Configure Environment Variables

Create a `.env` file with your configuration:

```bash
# Required
export DOMAIN="your-domain.com"
export ESTHESIS_HOSTNAME="esthesis.your-domain.com"
export KEYCLOAK_HOSTNAME="keycloak.your-domain.com"

# Credentials (change for production!)
export ESTHESIS_ADMIN_USERNAME="esthesis-admin"
export ESTHESIS_ADMIN_PASSWORD="your-secure-password"
export ESTHESIS_SYSTEM_USERNAME="esthesis-system"
export ESTHESIS_SYSTEM_PASSWORD="your-secure-password"

# Optional
export TIMEZONE="Europe/Athens"
export INGRESS_CLASS_NAME="nginx"
export IMAGE_PULL_SECRET=""  # If using private registry
```

Load the environment:

```bash
source .env
```

---

## Step 2: Add Helm Repository

```bash
helm repo add esthesis https://esthes.is/helm
helm repo update
```

---

## Step 3: Install Operators (Cluster-scoped)

The operators chart must be installed **once per cluster** (not per namespace):

```bash
# Update dependencies
cd esthesis-core-operators
helm dependency update
cd ..

# Install operators
helm install esthesis-operators ./esthesis-core-operators \
  --namespace esthesis-operators \
  --create-namespace \
  --wait
```

Verify operators are running:

```bash
kubectl get pods -n esthesis-operators
```

Expected output:
```
NAME                                        READY   STATUS    RESTARTS
strimzi-cluster-operator-xxx                1/1     Running   0
percona-server-mongodb-operator-xxx         1/1     Running   0
percona-pg-operator-xxx                     1/1     Running   0
```

---

## Step 4: Prepare values.yaml for Dependencies

Create a `values-deps.yaml` file:

```yaml
# Disable dev mode for production
devMode: false

# Domain configuration
domain: your-domain.com

# Timezone
timezone: "Europe/Athens"

# Credentials
esthesisAdminUsername: esthesis-admin
esthesisAdminPassword: "your-secure-password"
esthesisSystemUsername: esthesis-system
esthesisSystemPassword: "your-secure-password"

# Keycloak
keycloakx:
  fullnameOverride: "keycloak"
  
# Kafka (Strimzi)
kafka:
  name: "kafka"
  replicas: 3  # Production: 3 replicas
  storage:
    size: "50Gi"
  config:
    offsets.topic.replication.factor: "3"
    transaction.state.log.replication.factor: "3"
    default.replication.factor: "3"
    min.insync.replicas: "2"

# MongoDB (Percona)
psmdb-db:
  replsets:
    - name: rs0
      size: 3  # Production: 3 replicas
      volumeSpec:
        pvc:
          resources:
            requests:
              storage: 50Gi

# Redis
redis:
  persistence:
    enabled: true

# InfluxDB
influxdb2:
  persistence:
    size: "100Gi"

# Optional components
charts_enabled:
  grafana: true
  grafana-loki: true
  ingress-nginx: false  # Set true if no ingress controller
```

---

## Step 5: Install Dependencies

```bash
# Update dependencies
cd esthesis-core-deps
helm dependency update
cd ..

# Install
helm install esthesis-deps ./esthesis-core-deps \
  --namespace esthesis \
  --create-namespace \
  -f values-deps.yaml \
  --wait --timeout 15m
```

### Verify Dependencies

```bash
# Check all pods
kubectl get pods -n esthesis

# Check Strimzi Kafka cluster
kubectl get kafka -n esthesis

# Check Percona MongoDB
kubectl get psmdb -n esthesis

# Check Keycloak
kubectl get pods -n esthesis -l app.kubernetes.io/name=keycloakx
```

---

## Step 6: Install esthesis CORE Application

Create `values-core.yaml`:

```yaml
esthesisHostname: esthesis.your-domain.com
esthesisSystemUsername: esthesis-system
esthesisSystemPassword: "your-secure-password"

# Keycloak connection
keycloak:
  url: https://keycloak.your-domain.com
  
# MongoDB connection
mongodb:
  urlCluster: mongodb://mongodb:27017
  database: esthesiscore

# Kafka connection  
kafka:
  bootstrapServers: kafka-kafka-bootstrap:9092

# Redis connection
redis:
  hosts: redis-master:6379/0

# Camunda connection
camunda:
  gatewayUrlCluster: camunda-zeebe-gateway:26500
```

Install:

```bash
helm install esthesis-core ./esthesis-core \
  --namespace esthesis \
  -f values-core.yaml \
  --wait
```

---

## Step 7: Configure Ingress (if using external ingress)

If you have an existing ingress controller, create an Ingress:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: esthesis-ingress
  namespace: esthesis
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod  # If using cert-manager
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - esthesis.your-domain.com
        - keycloak.your-domain.com
      secretName: esthesis-tls
  rules:
    - host: esthesis.your-domain.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: esthesis-ui
                port:
                  number: 80
    - host: keycloak.your-domain.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: keycloak
                port:
                  number: 8080
```

---

## Step 8: Access the Application

1. **Access Keycloak** (initial setup):
   ```
   https://keycloak.your-domain.com
   ```
   Login with: `esthesis-system` / `your-secure-password`

2. **Access esthesis UI**:
   ```
   https://esthesis.your-domain.com
   ```
   Login with: `esthesis-admin` / `your-secure-password`

> **Note**: If using self-signed certificates, visit Keycloak URL first and accept the certificate before logging into the main application.

---

## Upgrade

```bash
# Update charts
helm repo update

# Upgrade operators (if new version)
helm upgrade esthesis-operators ./esthesis-core-operators \
  --namespace esthesis-operators

# Upgrade dependencies
helm upgrade esthesis-deps ./esthesis-core-deps \
  --namespace esthesis \
  -f values-deps.yaml

# Upgrade application
helm upgrade esthesis-core ./esthesis-core \
  --namespace esthesis \
  -f values-core.yaml
```

---

## Uninstall

```bash
# Remove in reverse order
helm uninstall esthesis-core -n esthesis
helm uninstall esthesis-deps -n esthesis
helm uninstall esthesis-operators -n esthesis-operators

# Delete PVCs (WARNING: data loss!)
kubectl delete pvc --all -n esthesis

# Delete namespaces
kubectl delete namespace esthesis esthesis-operators
```

---

## Troubleshooting

### Operators not creating resources

```bash
# Check operator logs
kubectl logs -n esthesis-operators -l app.kubernetes.io/name=strimzi-cluster-operator
kubectl logs -n esthesis-operators -l app.kubernetes.io/name=percona-server-mongodb-operator
```

### Kafka cluster not ready

```bash
kubectl describe kafka kafka -n esthesis
kubectl get kafkanodepool -n esthesis
```

### MongoDB cluster not ready

```bash
kubectl describe psmdb mongodb -n esthesis
```

### Keycloak not starting

```bash
kubectl logs -n esthesis -l app.kubernetes.io/name=keycloakx
```

---

## Production Recommendations

1. **Persistence**: Enable persistence for all stateful services
2. **Replicas**: Use 3+ replicas for Kafka, MongoDB, and Zeebe
3. **Resources**: Set appropriate CPU/memory requests and limits
4. **Secrets**: Use Kubernetes Secrets or external secret management
5. **Backup**: Configure regular backups for MongoDB, PostgreSQL, and InfluxDB
6. **Monitoring**: Enable Grafana and Loki for observability
7. **TLS**: Use cert-manager for automatic certificate management
